#!/bin/bash

ROOT_DIR=$(dirname $(readlink -f "$BASH_SOURCE"))
BIN_DIR=$PREFIX/bin
ENTRYPOINT_NAME=entrypoint.sh
LL_SOURCES_DIR=/project/linglong/sources
LL_SOURCES_LIST_DIR=/project/sources.d
LL_KELLER_LIBEXEC=$ROOT_DIR/../libexec
LL_KILLER_EXEC=$LL_KELLER_LIBEXEC/ll-killer
LL_ENTRYPOINT=$ROOT_DIR/$ENTRYPOINT_NAME
LL_ENTRYPOINT_BIN=$BIN_DIR/$ENTRYPOINT_NAME
LL_ENTRYPOINT_ROOT=$PREFIX/$ENTRYPOINT_NAME
LL_KILLER_SH=$ROOT_DIR/ll-killer

RES_DIR=$ROOT_DIR/../resources
SCRIPT_DIR=$ROOT_DIR
DPKG_EXEC=$SCRIPT_DIR/dpkg
APT_CONF=$RES_DIR/apt.conf

if [ -z "$LL_KELLER_PATH" ]; then
    export LL_KELLER_PATH=$LL_KELLER_LIBEXEC
    export PATH=$PATH:$LL_KELLER_PATH
fi
