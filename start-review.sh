#!/bin/bash

: '
  Starts a review:
    - Creates a directory for the review.
    - Copies the original icon.
    - Fetchs the branch and checkouts to it.

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

function main() {
    bash _review/create-review-dir.sh "$DIRNAME" "$ORIGINAL_ICON_NAME" || exit $?
    bash _review/fetch.sh "$USERNAME" "$BRANCH" || exit $?
}

main
