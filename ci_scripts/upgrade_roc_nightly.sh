#!/usr/bin/env bash

# Upgrades the examples to a newer Roc nightly, one example at a time.
# An example that does not work with the new nightly (yet) stays on its current version.
# Usage: ./ci_scripts/upgrade_roc_nightly.sh [NIGHTLY_TAG]
# Uses the latest nightly if no tag is given. Requires the same tools as all_tests.sh.

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

readonly tag="${1:-$(gh release view --repo roc-lang/nightlies --json tagName --jq .tagName)}"
roc="$(./ci_scripts/get_roc.sh "$tag")" || exit 1
readonly roc

upgraded=()
kept=()
for dir in examples/*/; do
  dir="${dir%/}"
  name="${dir##*/}"

  # Examples without code have nothing to pin.
  if [ -z "$(find "$dir" -name '*.roc' -print -quit)" ]; then
    continue
  fi

  old_version="$(./ci_scripts/example_roc_version.sh "$dir")" || exit 1
  if [ "$old_version" = "$tag" ]; then
    continue
  fi

  # Restoring from a copy instead of git, to keep any uncommitted changes.
  backup="$(mktemp -d)"
  cp -R "$dir/." "$backup/"

  ./ci_scripts/update_roc_version.sh "$tag" "$name" >/dev/null || exit 1

  # Formatting changes between nightlies, and roc fmt updates the pin as well.
  # The examples that are not formatted yet are left alone, like in check_format.sh.
  case "$name" in
    ElmWebApp | SortStrings) ;;
    *) find "$dir" -name '*.roc' -exec "$roc" fmt {} \; >/dev/null || true ;;
  esac

  # Unset ROC, the example must be tested with the nightly it pins now.
  ROC= ./ci_scripts/test_example.sh "$name" >/dev/null 2>&1
  status=$?

  # 3 means that the example is not tested yet, which is no reason to upgrade it.
  if [ "$status" -eq 0 ]; then
    upgraded+=("$name")
  else
    rm -rf "$dir"
    mkdir "$dir"
    cp -R "$backup/." "$dir/"
    kept+=("$name ($old_version)")
  fi
  rm -rf "$backup"
done

echo "Upgraded to $tag: ${upgraded[*]:-none}"
echo "Kept on their current version: ${kept[*]:-none}"
