#!/bin/bash
source $(dirname $0)/env.sh

PKG_INFO_FILE=${1:-package.info}

function pkg_info_local() {
    field="$1"
    cat "$PKG_INFO_FILE" | sed -n "/^$field:/,/^[^ ]/p" | sed -E -e "s/^$field://" | grep '^\s' | sed -e 's/^\s*//'
}
PKG_FOUND=$(cat ldd-found.log || true 2>/dev/null)
PKG=$(pkg_info_local Package)
PKG_VERSION=$(pkg_info_local Version)
if [ -n "$PKG_VERSION" ]; then
    PKG="$PKG=$PKG_VERSION"
fi
IFS=$' ,\n' read -r -a PKGS <<<"$(pkg_info_local Depends)"
apt update -y
dpkg --configure -a
echo Install: "$PKG" $PKG_FOUND "${PKGS[@]}"
INSTALLED=$(LANG=en apt list "$PKG" $PKG_FOUND "${PKGS[@]}" --installed 2>/dev/null | tail -n+2 | cut -d/ -f1)
if [ -n "$INSTALLED" ]; then
    echo Remove: "$INSTALLED"
    apt remove -y $INSTALLED || true
fi
if ! apt install --no-upgrade -yf "$PKG" $PKG_FOUND "${PKGS[@]}"; then
    CODE=$?
    echo "apt exited with code $CODE, fallback to dpkg-install..."
    apt install --no-upgrade -ydf "$PKG" $PKG_FOUND "${PKGS[@]}" && $SCRIPT_DIR/dpkg-install.sh
fi
