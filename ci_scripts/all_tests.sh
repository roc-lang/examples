#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

./roc_nightly/roc build ./examples/HelloWorld/main.roc

expect ci_scripts/expect_scripts/HelloWorld.exp
