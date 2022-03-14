#!/bin/bash

: '
  Opens Inkscape with two icon files prepared for compare them.
  First passed filepath is shown in black and second in green.
  
  Arguments:
    1. Filepath of icon shown in black.
    2. Filepath of icon shown in red.
  
  Options:
    -c,--center Centers the icon passed as second argument. 
'

BLACK_FILEPATH="$1"
RED_FILEPATH="$2"

if [ -z "$BLACK_FILEPATH" ]; then
    printf "You must specify a path to a SVG file compare using the" >&2
    printf " Inkscape GUI as first argument.\n" >&2
    exit 1
fi;
if [ -z "$RED_FILEPATH" ]; then
    printf "You must specify a path to a SVG file compare using the" >&2
    printf " Inkscape GUI as second argument.\n" >&2
    exit 1
fi;

CENTER=0

for arg in "$@"; do
  case $arg in
    -c|--center)
    CENTER=1
    shift
    ;;
  esac
done

function main() {
    RED_PATH_D="$(cat "$RED_FILEPATH" | cut -d'"' -f8)"
    TRANSLATE_X="26"
    if [ "$CENTER" -eq 1 ]; then
        TRANSLATE_X="0"
    fi;
    inkscape -g \
        --actions="select-by-element:path;EditCopy;EditPaste;object-set-attribute:fill, red;object-set-attribute:d, $RED_PATH_D;transform-translate:$TRANSLATE_X,0;" \
        "$BLACK_FILEPATH"
}

main
