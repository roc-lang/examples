#!/usr/bin/env bash

# Checks that all roc files are formatted with the Roc version that their example pins in its header.
# Set the ROC environment variable to use that roc binary for all examples instead.

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

# `roc fmt --check` all roc files
for file in $(find ./examples -name '*.roc'); do
    if [ -n "${ROC:-}" ]; then
        roc="$ROC"
    else
        # ./examples/<name>/...
        example_dir="$(cut -d/ -f1-3 <<<"$file")"
        roc="$(./ci_scripts/get_roc.sh "$(./ci_scripts/example_roc_version.sh "$example_dir")")"
    fi

    echo "Checking if $file was formatted with roc fmt..."
    "$roc" fmt --check "$file"
done
