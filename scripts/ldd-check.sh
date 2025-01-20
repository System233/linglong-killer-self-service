#!/bin/bash

find /opt /usr /lib /bin '(' -name "*.so" -or -executable ')' | xargs ldd 2>/dev/null | grep -F "=> not found" | sort -u | grep -oP '^\s*\K\S+'
