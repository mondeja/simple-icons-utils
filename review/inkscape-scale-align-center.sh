#!/bin/bash

: '
  Scales an SVG to make sure that measures 24x24 pixels and centers the path
  using Inkscape.
  
  Arguments:
    1. Input filepath.
    2. Output filepath.
'

INPUT_FILEPATH="$1"
OUTPUT_FILEPATH="$2"

if [ -z "$INPUT_FILEPATH" ]; then
    printf "You must specify a path to a SVG file for input as first" >&2
    printf " argument.\n" >&2
    exit 1
fi;
if [ -z "$OUTPUT_FILEPATH" ]; then
    printf "You must specify a path to a SVG file for output as second" >&2
    printf " argument.\n" >&2
    exit 1
fi;    

SELF_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

SCALE_DIFF=""
function computeScaleDifference() {
    PREVIOUS_DIMENSIONS="$(
        bash "$SELF_SCRIPT_DIR/inkscape-dimensions.sh" "$INPUT_FILEPATH" \
        || exit $?)"
    
    PREVIOUS_WIDTH=$(printf "$PREVIOUS_DIMENSIONS" | cut -d',' -f1)
    PREVIOUS_HEIGHT=$(printf "$PREVIOUS_DIMENSIONS" | cut -d',' -f2)
    
    echo "Previous width: $PREVIOUS_WIDTH"
    echo "Previous height: $PREVIOUS_HEIGHT"
    
    SCALE_DIFF=""
    if (( $(echo "$PREVIOUS_HEIGHT > $PREVIOUS_WIDTH" | bc -l) )); then
        SCALE_DIFF="$(echo "24 - $PREVIOUS_HEIGHT" | bc -l)"
    else
        SCALE_DIFF="$(echo "24 - $PREVIOUS_WIDTH" | bc -l)"
    fi;
}


function scaleAlignIconFile() {
    inkscape \
        --actions="select-by-element:path;transform-scale:${SCALE_DIFF/./,};AlignVerticalHorizontalCenter;" \
        --export-plain-svg \
        --batch-process \
        --export-filename="$OUTPUT_FILEPATH" \
        "$INPUT_FILEPATH" \
        || exit $?
}

function optimizeWithSVGO() {
    printf "Optimizing '$OUTPUT_FILEPATH' with SVGO\n"
    svgo --multipass --config .svgo.yml "$OUTPUT_FILEPATH" | grep Done || exit $?
    
    NEW_DIMENSIONS="$(
        bash "$SELF_SCRIPT_DIR/inkscape-dimensions.sh" "$OUTPUT_FILEPATH" \
        || exit $?)"
    
    NEW_WIDTH=$(printf "$NEW_DIMENSIONS" | cut -d',' -f1)
    NEW_HEIGHT=$(printf "$NEW_DIMENSIONS" | cut -d',' -f2)
    echo "New width: $NEW_WIDTH"
    echo "New height: $NEW_HEIGHT"
}

function main() {
    computeScaleDifference
    scaleAlignIconFile
    optimizeWithSVGO
}

main
