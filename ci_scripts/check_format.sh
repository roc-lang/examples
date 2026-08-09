#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail


if [ -z "${ROC}" ]; then
  echo "ERROR: The ROC environment variable is not set.
    Set it to the path of the roc executable." >&2

  exit 1
fi


# array of paths to exclude from format check
# TODO: update this once these examples are migrated
excludes=( './examples/ElmWebApp/backend.roc' './examples/SortStrings/main.roc' )

# Start the find command and loop through excludes to add them
find_command="find . -name '*.roc'"
for exclude in "${excludes[@]}"; do
    find_command+=" ! -path '$exclude*'"
done

# `roc fmt --check`` all roc files
for file in $(eval "$find_command"); do
    echo "Checking if $file was formatted with roc fmt..."
    $ROC fmt --check "$file"
done
