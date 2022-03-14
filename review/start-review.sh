#!/bin/bash

: '
  Starts a review:
    - Creates a directory for the review.
    - Copies the original icon.
    - Fetches the branch and checkouts to it.

  Arguments:
    1. Directory name for the review.
    2. Username of the owner of the branch to review.
    3. Branch name to review.
    4. Name of the original icon (only needed if the icon name is different to
      the directory name of the review.
  
  Example usage:
    bash _review/start.sh facebook service-paradis facebook-review
'

DIRNAME="$1"
USERNAME="$2"
BRANCH="$3"
ORIGINAL_ICON_NAME="$4"

if [ -z "$DIRNAME" ] && [ -z "$USERNAME" ]; then
    printf "You must specify a directory name where review files will be" >&2
    printf " located as first argument.\n" >&2
    exit 1
fi;
if [ -z "$USERNAME" ]; then
    printf "You must specify a user from which will be fetched the branch" >&2
    printf " to review as second argument.\n" >&2
    exit 1
fi;
if [ -z "$BRANCH" ]; then
    printf "You must specify a branch name to review as third argument.\n" >&2
    exit 1
fi;

SELF_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function main() {
    if [ -n "$DIRNAME" ]; then
        bash "$SELF_SCRIPT_DIR/create-review-dir.sh" "$DIRNAME" "$ORIGINAL_ICON_NAME" \
            || exit $?
    fi;
    bash "$SELF_SCRIPT_DIR/fetch.sh" "$USERNAME" "$BRANCH" || exit $?
}

main
