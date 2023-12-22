#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail


if [ -z "${ROC}" ]; then
  echo "ERROR: The ROC environment variable is not set.
    Set it to something like:
        /home/username/Downloads/roc_nightly-linux_x86_64-2023-10-30-cb00cfb/roc
        or
        /home/username/gitrepos/roc/target/build/release/roc
        or
        ./roc_nightly/roc" >&2

  exit 1
fi

# array of paths to exclude from format check
# TODO: remove the exclusion of examples/Tasks/main.roc when
# https://github.com/roc-lang/roc/issues/6074 is done
excludes=( './examples/Tasks/main.roc' './roc_nightly/' )

# Start the find command and loop through excludes to add them
find_command="find . -name '*.roc'"
for exclude in "${excludes[@]}"; do
    find_command+=" ! -path '$exclude*'"
done

# `roc format --check`` all roc files
for file in $(eval "$find_command"); do
    echo "Checking if $file was formatted with roc format..."
    $ROC format --check "$file"
done
