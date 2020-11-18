#!/bin/bash

: '
  Shows differences between two files using GIT.
  
  Arguments:
    1. Filepath of previous content, shown in red.
    1. Filepath of new content, shown in green.
'

RED_FILEPATH="$1"
GREEN_FILEPATH="$2"

if [ -z "$RED_FILEPATH" ]; then
    printf "You must specify a filepath to compare from as first argument.\n" >&2
    exit 1
fi;
if [ -z "$GREEN_FILEPATH" ]; then
    printf "You must specify a filepath to compare to as second argument.\n" >&2
    exit 1
fi;

function main() {
    git diff --no-index --word-diff=color --word-diff-regex=. \
        "$RED_FILEPATH" "$GREEN_FILEPATH" 
}

main
