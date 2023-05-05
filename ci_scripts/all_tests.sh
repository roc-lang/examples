#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

roc='./roc_nightly/roc'

$roc build ./examples/HelloWorld/main.roc
expect ci_scripts/expect_scripts/HelloWorld.exp

$roc build ./examples/Arithmetic/main.roc
expect ci_scripts/expect_scripts/Arithmetic.exp

$roc build ./examples/FizzBuzz/main.roc
$roc test ./examples/FizzBuzz/main.roc
expect ci_scripts/expect_scripts/FizzBuzz.exp

$roc test ./examples/GraphTraversal/Graph.roc

# TODO enable once fixed: $roc build ./examples/JsonBasic/main.roc
$roc run ./examples/JsonBasic/main.roc
# TODO add expect script test, as well as build test once the JsonBasic example is fixed

$roc build ./examples/LeastSquares/main.roc
expect ci_scripts/expect_scripts/LeastSquares.exp

$roc build ./examples/ParserBasic/main.roc
$roc test ./examples/ParserBasic/main.roc
expect ci_scripts/expect_scripts/ParserBasic.exp

# TODO fix pattern matching failing test
# $roc test ./examples/PatternMatching/PatternMatching.roc

$roc build ./examples/RandomNumbers/main.roc
expect ci_scripts/expect_scripts/RandomNumbers.exp

$roc build ./examples/TowersOfHanoi/main.roc
$roc test ./examples/TowersOfHanoi/Hanoi.roc
expect ci_scripts/expect_scripts/TowersOfHanoi.exp
