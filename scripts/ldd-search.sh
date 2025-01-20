#!/bin/bash
FOUND=${2:-/dev/stdout}
MISSING=${3:-/dev/stderr}
SEARCHED=$(apt-file find -f ${1:--} | grep '^lib' | sort -u)
grep -Fvf <(echo "$SEARCHED" | awk -F/ '{print $NF}') ldd-check.log >$MISSING
echo "$SEARCHED" | cut -d: -f1 | sort -u >$FOUND
