#!/bin/bash
if [ -n "$DEBUG" ]; then
    set -x
fi
ROOT_DIR=$(dirname $(readlink -f "$0"))
source $ROOT_DIR/env.sh
TEMPLATE="$RES_DIR/template.yaml"
PKG_INFO_FILE=${1:-package.info}

OUTPUT="${GEN_YAML_OUTPUT:-linglong.yaml}"

function pkg_info_local() {
    field="$1"
    cat "$PKG_INFO_FILE" | sed -n "/^$field:/,/^[^ ]/p" | sed -e "s/^$field://" | grep '^\s' | sed -e "s/^\s*//"
}
function pkg_info() {
    pkg="$1"
    field="$2"
    result=$(pkg_info_local "$field")
    if [ -z "$result" ]; then
        result=$(apt-cache show "$pkg" --no-all-versions | sed -n "/^$field:/,/^[^ ]/p" | sed -e "s/^$field://" | grep '^\s' | sed -e "s/^\s*//")
    fi
    echo "$result"
}
function version() {
    local version="$1"
    version=$(echo $version | sed -E -e 's/[^0-9\.]+/\./g')
    IFS='.' read -r -a fields <<<"$version"
    for i in {0..3}; do
        fields[i]=$(echo ${fields[$i]} | sed -e 's/^0//g' -e 's/[^0-9.]//g')
        if [ -z "${fields[$i]}" ]; then
            fields[$i]=0
        fi
    done
    echo "${fields[0]}.${fields[1]}.${fields[2]}.${fields[3]}"
}
function assert() {
    if [ -z "$1" ]; then
        echo "$2" >&2
        exit 1
    fi
}

if [ -z "$MAIN_PKG" ]; then
    MAIN_PKG=$(pkg_info_local Package)
fi

PKG_DESC=$(pkg_info $MAIN_PKG Description)
PKG_VERSION=$(pkg_info $MAIN_PKG Version | head -n1)
PKG_DEPS=$(pkg_info $MAIN_PKG Depends)
PKG_ID=$(pkg_info $MAIN_PKG Package | head -n1)
PKG_NAME=$(pkg_info $MAIN_PKG Name | head -n1)
PKG_NAME=${PKG_NAME:-$PKG_ID}

APP_ID=${PKG_ID}
APP_VER=$(version "$PKG_VERSION")
APP_NAME=${APP_NAME:-$PKG_NAME}
APP_DESC=${APP_DESC:-$PKG_DESC}
APP_BASE=$(pkg_info_local Base | head -n1)
APP_RUNTIME=$(pkg_info_local Runtime | head -n1)
APP_SOURCES=$(pkg_info_local APT-Sources)

DEFAULT_BASE=${DEFAULT_BASE:-"org.deepin.base/23.1.0"}
APP_BASE=${APP_BASE:-$DEFAULT_BASE}

assert "$APP_ID" "'Package' not defined"
PKG=$(pkg_info_local Package)
PKG_VERSION=$(pkg_info_local Version)
if [ -n "$PKG_VERSION" ]; then
    PKG="$PKG=$PKG_VERSION"
fi
apt-cache show "$PKG" || exit 1

cp "$TEMPLATE" "$OUTPUT"

APP_DESC_IDENTED=$(echo "$APP_DESC" | sed -E -e 's/^\s*//' -e 's/^/    /')
APP_ID="$APP_ID" perl -i -pe 's/{APP_ID}/$ENV{APP_ID}/' "$OUTPUT"
APP_DESC="$APP_DESC_IDENTED" perl -i -pe 's/{APP_DESC}/$ENV{APP_DESC}/' "$OUTPUT"
APP_VER="$APP_VER" perl -i -pe 's/{APP_VER}/$ENV{APP_VER}/' "$OUTPUT"
APP_NAME="$APP_NAME" perl -i -pe 's/{APP_NAME}/$ENV{APP_NAME}/' "$OUTPUT"
APP_BASE="$APP_BASE" perl -i -pe 's/{APP_BASE}/$ENV{APP_BASE}/' "$OUTPUT"
APP_RUNTIME="$APP_RUNTIME" perl -i -pe 's/{APP_RUNTIME}/$ENV{APP_RUNTIME}/' "$OUTPUT"
PKG_INFO_FILE="$PKG_INFO_FILE" perl -i -pe 's/{PKG_INFO_FILE}/$ENV{PKG_INFO_FILE}/' "$OUTPUT"

LL_KILLER_EXEC=$(realpath "--relative-to=$(pwd)" "$LL_KILLER_SH") perl -i -pe 's/{LL_KILLER_EXEC}/$ENV{LL_KILLER_EXEC}/' "$OUTPUT"
echo "$APP_SOURCES" >sources.list
