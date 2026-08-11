#!/usr/bin/env bash

set -euo pipefail

readonly roc_version="$(<.roc-version)"
readonly version_pattern='roc: "nightly-[^"]+"'

if [[ ! "$roc_version" =~ ^nightly-[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9a-f]+$ ]]; then
  echo ".roc-version must contain a nightly release tag, got: $roc_version" >&2
  exit 1
fi

while IFS= read -r manifest; do
  if ! grep -Fq "roc: \"$roc_version\"" "$manifest"; then
    echo "$manifest does not use the pinned Roc version $roc_version" >&2
    exit 1
  fi
done < <(rg -l "$version_pattern" examples)
