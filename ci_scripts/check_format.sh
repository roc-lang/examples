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

# opt-in list of files to format check (add files as they are updated for the new compiler)
optin=(
  "examples/TryOperatorDesugaring/main.roc"
)

for file in "${optin[@]}"; do
    echo "Checking if $file was formatted with roc fmt..."
    $ROC fmt --check "$file"
done
