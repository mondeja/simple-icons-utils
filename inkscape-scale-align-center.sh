#!/bin/bash

SCALE_DIFF=""
function computeScaleDifference() {
    PREVIOUS_WIDTH_HEIGHT=$(inkscape --query-all prueba-in.svg \
                            | grep path \
                            | cut -d',' -f4-)
    
    PREVIOUS_WIDTH=$(printf "$PREVIOUS_WIDTH_HEIGHT" | cut -d',' -f1)
    PREVIOUS_HEIGHT=$(printf "$PREVIOUS_WIDTH_HEIGHT" | cut -d',' -f2)
    
    SCALE_DIFF=""
    if [ "$PREVIOUS_HEIGHT" -gt "$PREVIOUS_WIDTH" ]; then
        let SCALE_DIFF=24-$PREVIOUS_HEIGHT
    else
        let SCALE_DIFF=24-$PREVIOUS_WIDTH
    fi;
}

function scaleAlignIconFile() {
    inkscape \
        --actions="select-by-element:path;transform-scale:$SCALE_DIFF;AlignVerticalHorizontalCenter;" \
        --export-plain-svg \
        --batch-process \
        --export-filename="prueba.svg" \
        prueba-in.svg
}

function main() {
    computeScaleDifference
    scaleAlignIconFile
}

main
