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

SCALE_DIFF=""
function computeScaleDifference() {
    PREVIOUS_DIMENSIONS=$(inkscape --query-all "$INPUT_FILEPATH" \
                            | grep path \
                            | cut -d',' -f4-)
    
    PREVIOUS_WIDTH=$(printf "$PREVIOUS_DIMENSIONS" | cut -d',' -f1)
    PREVIOUS_HEIGHT=$(printf "$PREVIOUS_DIMENSIONS" | cut -d',' -f2)
    
    #echo "w: $PREVIOUS_WIDTH | h: $PREVIOUS_HEIGHT"
    
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
        "$INPUT_FILEPATH"
}

function main() {
    computeScaleDifference
    scaleAlignIconFile
}

main
