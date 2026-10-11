#!/usr/bin/env bash

# Prints the nightly tag that an example pins in its header, e.g. nightly-2026-10-09-258ab27.
# Usage: ./ci_scripts/example_roc_version.sh examples/Commands

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: example_roc_version.sh EXAMPLE_DIR" >&2
  exit 1
fi

# An example may spread over several files, only the one with the app header has a pin.
versions="$(grep -rhoE --include='*.roc' 'roc: "nightly-[^"]+"' "$1" | sed -E 's/^roc: "(.*)"$/\1/' | sort -u)"

if [ -z "$versions" ]; then
  echo "$1 does not pin a Roc version, add roc: \"nightly-...\" to its app header" >&2
  exit 1
elif [ "$(wc -l <<<"$versions")" -ne 1 ]; then
  echo "$1 pins more than one Roc version:" >&2
  echo "$versions" >&2
  exit 1
fi

echo "$versions"
