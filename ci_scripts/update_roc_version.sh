#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail

if [ "$#" -lt 1 ]; then
    echo "Usage: ./update_roc_version.sh NEW_ROC_VERSION [EXAMPLE_NAME...]" >&2
    echo "Example: ./update_roc_version.sh nightly-2026-08-11-56acb9b Commands Snake" >&2
    echo "Without example names, all examples are updated." >&2
    exit 1
fi

readonly new_version="$1"
shift

if [[ ! "$new_version" =~ ^nightly-[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9a-f]+$ ]]; then
  echo "expected a nightly release tag like nightly-2026-08-10-7df8509, got: $new_version" >&2
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [ "$#" -gt 0 ]; then
  dirs=()
  for name in "$@"; do
    dirs+=("examples/$name")
  done
else
  dirs=(examples)
fi

# Update every tracked file that pins a roc version in its header
while IFS= read -r file; do
  perl -pi -e "s|roc: \"nightly-[^\"]+\"|roc: \"$new_version\"|g" "$file"
done < <(git grep -l -E 'roc: "nightly-[^"]+"' -- "${dirs[@]}")

echo "Pinned Roc version of ${*:-all examples} updated to $new_version."
