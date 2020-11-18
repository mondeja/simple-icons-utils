#!/bin/bash

: '
  Shows dimensions of SVG path using inkscape separated by a comma in the
  form WIDTH,HEIGHT.
  
  Arguments:
    1. Filepath to query dimensiones.
'

FILEPATH="$1"

if [ -z "$FILEPATH" ]; then
    printf "You must specify a path to a SVG file to query their dimensions" >&2
    printf " as first argument.\n" >&2
    exit 1
fi;

function main() {
    inkscape --query-all "$FILEPATH" \
        | grep path \
        | cut -d',' -f4- \
        || exit $?
}

main
