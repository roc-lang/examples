#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

roc='./roc_nightly/roc'

# TODO: remove the exclusion of examples/Tasks/main.roc when
# https://github.com/roc-lang/roc/issues/6074 is done
to_exclude='./examples/Tasks/main.roc'

for file in $(find . -name "*.roc" ! -path "$to_exclude"); do
    echo "Checking if $file needs to be formatted with roc format..."
    $roc format --check "$file"
done
