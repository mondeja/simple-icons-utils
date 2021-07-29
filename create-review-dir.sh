
: '
  Creates a directory for make a review. Passing a second argument or
  if the directory name match with an icon located at "icons" folder,
  copies the icon to the new directory renaming it as "original.svg".
  If does not matches and this second argument is not passed, the
  created icon will be an empty icon.
  
  Arguments:
  
    1. Directory name.
    2. Original icon name.
'

DIRNAME="$1"
ORIGINAL_ICON_NAME="$2"

if [ -z "$DIRNAME" ]; then
    printf "You must specify a directory name as the first argument.\n" >&2
    exit 1
fi;

function createDirectory() {
    if [ ! -d "_review" ]; then
        mkdir _review
    fi;
    if [ -d "_review/$DIRNAME" ]; then
        printf "ERROR: Directory '_review/$DIRNAME' exists\n" >&2
        exit 1
    fi;
    mkdir "_review/$DIRNAME"
    printf "Created directory '_review/%s'\n" "$DIRNAME"
}

function createOriginalIcon() {
    if [ "$ORIGINAL_ICON_NAME" = "" ]; then
        ORIGINAL_ICON_NAME="$DIRNAME"
    fi;
    
    if [ -f "icons/$ORIGINAL_ICON_NAME.svg" ]; then
        cp "icons/$ORIGINAL_ICON_NAME.svg" "_review/$DIRNAME/original.svg"
        printf "Copied '_review/%s/original.svg' from 'icons/%s.svg'\n" \
            "$DIRNAME" "$ORIGINAL_ICON_NAME"
    else
        printf '<svg role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><title></title><path d=""/></svg>' \
            > "_review/$DIRNAME/empty.svg"
        printf "Created empty icon '_review/%s/empty.svg'\n" "$DIRNAME"
    fi;
}

function main() {
    createDirectory
    createOriginalIcon
}

main
