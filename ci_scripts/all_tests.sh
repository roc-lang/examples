#!/usr/bin/env bash

# Tests all examples, or only the given ones, each with the Roc version it pins in its header.
# Usage: ./ci_scripts/all_tests.sh [EXAMPLE_NAME...]
#
# Set the ROC environment variable to use that roc binary for all examples instead of the pinned nightlies.

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

if [ "$#" -gt 0 ]; then
  names=("$@")
else
  names=()
  for dir in examples/*/; do
    dir="${dir%/}"
    names+=("${dir##*/}")
  done
fi

failed=()
for name in "${names[@]}"; do
  echo "=== Testing $name ==="
  # Exit code 3 means that the example is not tested yet.
  ./ci_scripts/test_example.sh "$name"
  status=$?
  if [ "$status" -ne 0 ] && [ "$status" -ne 3 ]; then
    failed+=("$name")
  fi
done

if [ "${#failed[@]}" -gt 0 ]; then
  echo "These examples failed: ${failed[*]}" >&2
  exit 1
fi

echo "All tests passed!"
