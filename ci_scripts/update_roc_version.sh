#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail

# Check if the correct number of arguments is given
if [ "$#" -ne 1 ]; then
    echo "Usage: ./update_roc_version.sh NEW_ROC_VERSION" >&2
    echo "Example: ./update_roc_version.sh nightly-2026-08-11-56acb9b" >&2
    exit 1
fi

readonly new_version="$1"

if [[ ! "$new_version" =~ ^nightly-[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9a-f]+$ ]]; then
  echo "expected a nightly release tag like nightly-2026-08-10-7df8509, got: $new_version" >&2
  exit 1
fi

echo "$new_version" > .roc-version

# Update every tracked file that pins a roc version in its manifest
while IFS= read -r file; do
  perl -pi -e "s|roc: \"nightly-[^\"]+\"|roc: \"$new_version\"|g" "$file"
done < <(git grep -l -E 'roc: "nightly-[^"]+"' -- examples)

echo "Pinned Roc version updated to $new_version."
