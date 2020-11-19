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

if [ -z "$USERNAME" ]; then
    printf "You must specify an username to fetch the branch from as" >&2
    printf " first argument.\n" >&2
    exit 1
fi;
if [ -z "$BRANCH" ]; then
    printf "You must specify a branch name to fetch as second argument.\n" >&2
    exit 1
fi;

function checkoutDevelopIfNotChecked() {
    current_branch="$(git rev-parse --abbrev-ref HEAD || exit $?)"
    if [ "$current_branch" != "develop" ]; then
        git checkout develop || exit $?
    fi;
}

function addRemoteIfNotAdded() {
    CHECKED="$(git remote -v \
        | grep -E "^$USERNAME" \
        | head -n 1 \
        | cut -d'(' -f2 \
        | tr -d ')')"
    if [ "$CHECKED" != "fetch" ]; then
        git remote add "$USERNAME" "https://github.com/$USERNAME/simple-icons.git"
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
    addRemoteIfNotAdded
    fetchBranch
    checkoutTemporalBranch
}

main
