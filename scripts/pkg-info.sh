#!/bin/bash
field="$1"
PKG_INFO_FILE=${2:-package.info}
cat "${PKG_INFO_FILE}" | sed -n "/^$field:/,/^[^ ]/p" | sed -E -e "s/^$field://" | grep '^\s' | sed -e 's/^\s*//'
