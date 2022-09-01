#!/usr/bin/env sh

# Generated tables only fill the name of the project, for now
# does not guess their donations form, importance nor project type

EXITCODE=0

SIMPLE_ICONS_PROJECTS="simple-icons
simple-icons-font
simple-icons-website
release-action"

# Get package.json dependencies and devDependencies
# of a project.
#
# Args:
#   $1 -> Repository name (repository owner always will be simple-icons)
get_project_packagejson_dependencies() {
  local repo_name
  repo_name="$1"

  if [ -d /tmp/$repo_name ]; then
    rm -rf /tmp/$repo_name
  fi

  git clone --depth=1 \
    https://github.com/simple-icons/$repo_name.git \
    /tmp/$repo_name > /dev/null 2>&1

  # simple-icons only has development dependencies
  local dependencies
  dependencies=""

  if [ "$(cat /tmp/$repo_name/package.json | grep '"dependencies"' )" != "" ]; then
    if [ "$dependencies" != "" ]; then
      dependencies="$dependencies\n"
    fi
    dependencies="$dependencies$(
      cat /tmp/$repo_name/package.json \
      | jq -r '.dependencies | keys[]')"
  fi;

  if [ "$(cat /tmp/$repo_name/package.json | grep '"devDependencies"' )" != "" ]; then
    if [ "$dependencies" != "" ]; then
      dependencies="$dependencies\n"
    fi
    dependencies="$dependencies$(
      cat /tmp/$repo_name/package.json \
      | jq -r '.devDependencies | keys[]')"
  fi;

  echo "$dependencies"
}

# Print the table of dependencies of a project
#
# Args:
#   $1 -> Repository name
print_project_dependencies_table() {
  local repo_name
  repo_name="$1"

  local dependencies
  dependencies="$(get_project_packagejson_dependencies $repo_name)"

  printf "## $repo_name\n\n"
  printf '| Dependency | Accepts Donations | Importance | Project Type |\n'
  printf '| --- | --- | --- | --- |\n'

  echo "$dependencies" | while read -r dep; do
    if [ "$(echo $SIMPLE_ICONS_PROJECTS | grep "$dep")" = "" ]; then
      # don't print our own packages as dependencies
      printf "| [$dep](https://npmjs.com/package/$dep) |  |  |  |\n"
    fi
  done
  printf '\n'
}

check_dependencies() {
  if ! which jq > /dev/null; then
    printf "You need to install jq to run this script\n" >&2
    EXITCODE=1
  fi;
}

main() {
  check_dependencies
  if [ "$EXITCODE" -ne 0 ]; then
    exit $EXITCODE
  fi

  echo "$SIMPLE_ICONS_PROJECTS" | while read -r project; do
    print_project_dependencies_table "$project"
  done
}

main
