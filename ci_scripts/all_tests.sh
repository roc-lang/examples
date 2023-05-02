#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

./roc_nightly/roc build ./examples/HelloWorld/main.roc
expect ci_scripts/expect_scripts/HelloWorld.exp

./roc_nightly/roc build ./examples/Arithmetic/main.roc
expect ci_scripts/expect_scripts/Arithmetic.exp

./roc_nightly/roc build ./examples/FizzBuzz/main.roc
./roc_nightly/roc test ./examples/FizzBuzz/main.roc
expect ci_scripts/expect_scripts/FizzBuzz.exp

./roc_nightly/roc test ./examples/GraphTraversal/Graph.roc

# TODO enable once fixed: ./roc_nightly/roc build ./examples/json-basic/main.roc
./roc_nightly/roc run ./examples/json-basic/main.roc
# TODO add expect script test, as well as build test once the json-basic example is fixed

./roc_nightly/roc build ./examples/LeastSquares/main.roc
expect ci_scripts/expect_scripts/LeastSquares.exp

./roc_nightly/roc build ./examples/parser-basic/main.roc
./roc_nightly/roc test ./examples/parser-basic/main.roc
expect ci_scripts/expect_scripts/parser-basic.exp

# TODO fix pattern matching failing test
# ./roc_nightly/roc test ./examples/PatternMatching/PatternMatching.roc

./roc_nightly/roc build ./examples/RandomNumbers/main.roc
expect ci_scripts/expect_scripts/RandomNumbers.exp

./roc_nightly/roc build ./examples/TowersOfHanoi/main.roc
./roc_nightly/roc test ./examples/TowersOfHanoi/Hanoi.roc
expect ci_scripts/expect_scripts/TowersOfHanoi.exp
