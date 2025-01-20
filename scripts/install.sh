#!/bin/bash
set -e
ROOT_DIR=$(dirname $(readlink -f "$0"))
$ROOT_DIR/ll-killer -- "$@" || ${ROOT_DIR}/ll-killer extract "$?"
$ROOT_DIR/ll-killer install
$ROOT_DIR/ll-killer setup
