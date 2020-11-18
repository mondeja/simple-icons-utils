#!/bin/bash

: '
  Shows differences between two files using GIT.
  
  Arguments:
    1. Filepath of previous content, shown in red.
    1. Filepath of new content, shown in green.
'

RED_FILEPATH="$1"
GREEN_FILEPATH="$2"

function main() {
    git diff --no-index --word-diff=color --word-diff-regex=. \
        "$RED_FILEPATH" "$GREEN_FILEPATH" 
}

main
