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

$ROC build ./examples/HelloWorld/main.roc
expect ci_scripts/expect_scripts/HelloWorld.exp

$ROC build ./examples/Arithmetic/main.roc
expect ci_scripts/expect_scripts/Arithmetic.exp

$ROC build ./examples/FizzBuzz/main.roc
$ROC test ./examples/FizzBuzz/main.roc
expect ci_scripts/expect_scripts/FizzBuzz.exp

$ROC test ./examples/GraphTraversal/Graph.roc

$ROC build ./examples/Json/main.roc --linker=legacy
expect ci_scripts/expect_scripts/Json.exp

$ROC build ./examples/LeastSquares/main.roc
expect ci_scripts/expect_scripts/LeastSquares.exp

$ROC build ./examples/IngestFiles/main.roc
expect ci_scripts/expect_scripts/IngestFiles.exp

$ROC build ./examples/Parser/main.roc
$ROC test ./examples/Parser/main.roc
expect ci_scripts/expect_scripts/Parser.exp

$ROC test ./examples/PatternMatching/PatternMatching.roc

$ROC build ./examples/RandomNumbers/main.roc
expect ci_scripts/expect_scripts/RandomNumbers.exp

$ROC build ./examples/CommandLineArgs/main.roc
expect ci_scripts/expect_scripts/CommandLineArgs.exp

$ROC build ./examples/Tuples/main.roc
expect ci_scripts/expect_scripts/Tuples.exp

$ROC test ./examples/TowersOfHanoi/Hanoi.roc

$ROC build ./examples/Tasks/main.roc
expect ci_scripts/expect_scripts/Tasks.exp

$ROC build ./examples/TaskLoop/main.roc
expect ci_scripts/expect_scripts/TaskLoop.exp

$ROC test ./examples/RecordBuilder/IDCounter.roc

$ROC test ./examples/BasicDict/BasicDict.roc

$ROC build ./examples/MultipleRocFiles/main.roc
expect ci_scripts/expect_scripts/MultipleRocFiles.exp

$ROC build ./examples/ImportFromDirectory/main.roc
expect ci_scripts/expect_scripts/ImportFromDirectory.exp

$ROC build ./examples/EncodeDecode/main.roc
expect ci_scripts/expect_scripts/EncodeDecode.exp

$ROC build --lib ./examples/GoPlatform/main.roc --output examples/GoPlatform/platform/libapp.so
go build -C examples/GoPlatform/platform -buildmode=pie -o dynhost

$ROC preprocess-host ./examples/GoPlatform/main.roc
$ROC build --prebuilt-platform ./examples/GoPlatform/main.roc

# temporarily allow failure of lsb_release in case it is not installed
set +e
os_info=$(lsb_release -a 2>/dev/null)
set -e

# Check if the OS is not Ubuntu 20.04. Avoids segfault on CI.
if ! echo "$os_info" | grep -q "Ubuntu 20.04"; then
    expect ci_scripts/expect_scripts/GoPlatform.exp
fi

$ROC build ./examples/DotNetPlatform/main.roc --lib --output ./examples/DotNetPlatform/platform/interop
expect ci_scripts/expect_scripts/DotNetPlatform.exp
$roc build ./examples/SafeMath/main.roc
$roc test ./examples/SafeMath/main.roc
expect ci_scripts/expect_scripts/SafeMath.exp

# test building website
$roc run main.roc -- examples build
