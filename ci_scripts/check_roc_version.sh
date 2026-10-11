#!/usr/bin/env bash

# Checks that every example pins exactly one Roc nightly in its header, e.g. roc: "nightly-2026-10-09-258ab27".
# Each example is tested with its own pinned version, so examples can be upgraded one by one.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

for dir in examples/*/; do
  dir="${dir%/}"

  # Examples without code have nothing to pin.
  if [ -z "$(find "$dir" -name '*.roc' -print -quit)" ]; then
    continue
  fi

  ./ci_scripts/example_roc_version.sh "$dir" >/dev/null
done

# Every app header needs the pin, including the apps of multi-file examples.
missing="$(grep -rL --include='*.roc' 'roc: "nightly-' $(grep -rl --include='*.roc' '^app \[' examples) || true)"
if [ -n "$missing" ]; then
  echo "These app headers do not pin a Roc version:" >&2
  echo "$missing" >&2
  exit 1
fi
