#!/bin/bash

FILEPATH="$1"
DIRECTORY="$2"

if [ -z "$FILEPATH" ]; then
    printf "You must pass a path to a file containing glyphs in SVG format" >&2
    printf " as first argument.\n" >&2
    exit
fi;

if [ -z "$DIRECTORY" ]; then
    printf "You must pass a path to a folder where will be stored created" >&2
    printf " SVGs extracted from glyphs.\n" >&2
    exit 1
fi;
if [ -d "$DIRECTORY" ]; then
    printf "The directory '$DIRECTORY' exists yet. Please, pass a path to a" >&2
    printf " directory non existent currently in your system as second" >&2
    printf " argument.\n" >&2
    exit 1
fi;

_PATHS=""
function extractGlyphPaths() {
    prev_char=""
    _entering_d=0
    _inside_d=0
    
    _current_path=""
    while IFS=: read -n1 c; do
        if [ "$prev_char" = "d" ] && [ "$c" = "=" ] && [ "$_inside_d" -eq 0 ]; then
            _entering_d=1
        elif [ "$_entering_d" -eq 1 ] && [ "$c" = '"' ]; then
            _entering_d=0
            _inside_d=1
        elif [ "$_inside_d" -eq 1 ] && [ "$c" = '"' ]; then
            _inside_d=0
            _PATHS="$_PATHS
$_current_path"
            _current_path=""
        elif [ "$_inside_d" -eq 1 ]; then
            _current_path="${_current_path}${c}"
        fi;
        prev_char="$c"
    done < "$FILEPATH"
}

function buildSvgFiles() {
    mkdir -p "$DIRECTORY"
    
    i=0
    while IFS= read -r path; do
        if [ -z "$path" ] || [ "${path:0:1}" != "M" ]; then
            continue
        fi;
        i=$((i+1))
        printf "<svg xmlns=\"http://www.w3.org/2000/svg\"><path d=\"$path\"/></svg>" > "$DIRECTORY/$i.svg"
    done <<< "$_PATHS"
    
    printf "%s glyphs extracted.\n" "$i"

}

function main() {
    extractGlyphPaths
    buildSvgFiles
}

main
