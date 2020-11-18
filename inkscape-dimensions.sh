#!/bin/bash

: '
  Shows dimensions of SVG path using inkscape separated by a comma in the
  form WIDTH,HEIGHT.
  
  Arguments:
    1. Filepath to query dimensiones.
'

FILEPATH="$1"

function main() {
    inkscape --query-all "$FILEPATH" \
        | grep path \
        | cut -d',' -f4- \
        || exit $?
}

main
