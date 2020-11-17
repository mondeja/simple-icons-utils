#!/bin/bash

: '
  Fetchs a remote branch and creates a correspondent temporal branch
  checking out to it.
  
  Arguments:
    1. Username owner of the branch.
    2. Name of the branch.
'

USERNAME="$1"
BRANCH="$2"

function checkoutDevelopIfNotChecked() {
    current_branch="$(git rev-parse --abbrev-ref HEAD || exit $?)"
    if [ "$current_branch" != "develop" ]; then
        git checkout develop || exit $?
    fi;
}

function fetchBranch() {
    git fetch $USERNAME $BRANCH || exit $?
}

function checkoutTemporalBranch() {
    git checkout -t "${USERNAME}/${BRANCH}" || exit $?
}

function main() {
    checkoutDevelopIfNotChecked
    fetchBranch
    checkoutTemporalBranch
}

main
