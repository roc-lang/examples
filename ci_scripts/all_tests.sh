#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -exo pipefail

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

$ROC build ./examples/Commands/main.roc
expect ci_scripts/expect_scripts/Commands.exp

$ROC build ./examples/CommandLineArgsFile/main.roc
expect ci_scripts/expect_scripts/CommandLineArgsFile.exp

$ROC build ./examples/TryOperatorDesugaring/main.roc
$ROC test ./examples/TryOperatorDesugaring/main.roc
expect ci_scripts/expect_scripts/TryOperatorDesugaring.exp

$ROC build ./examples/Tuples/main.roc
expect ci_scripts/expect_scripts/Tuples.exp

$ROC test ./examples/TowersOfHanoi/Hanoi.roc

$ROC test ./examples/ErrorHandlingBasic/ErrorHandlingBasic.roc

$ROC build ./examples/ErrorHandlingRealWorld/main.roc
expect ci_scripts/expect_scripts/ErrorHandlingRealWorld.exp

$ROC build ./examples/LoopEffect/main.roc
expect ci_scripts/expect_scripts/LoopEffect.exp

$ROC build ./examples/Snake/main.roc
$ROC test ./examples/Snake/main.roc
expect ci_scripts/expect_scripts/Snake.exp

$ROC test ./examples/RecordBuilder/DateParser.roc

$ROC test ./examples/BasicDict/BasicDict.roc

$ROC build ./examples/MultipleRocFiles/main.roc
expect ci_scripts/expect_scripts/MultipleRocFiles.exp

$ROC build ./examples/ImportFromDirectory/main.roc
expect ci_scripts/expect_scripts/ImportFromDirectory.exp

$ROC build ./examples/EncodeDecode/main.roc
expect ci_scripts/expect_scripts/EncodeDecode.exp

$ROC build ./examples/SafeMath/main.roc
$ROC test ./examples/SafeMath/main.roc
expect ci_scripts/expect_scripts/SafeMath.exp

$ROC build ./examples/HelloWeb/main.roc --linker=legacy
expect ci_scripts/expect_scripts/HelloWeb.exp

$ROC build ./examples/ImportPackageFromModule/main.roc
expect ci_scripts/expect_scripts/ImportPackageFromModule.exp

$ROC test ./examples/CustomInspect/OpaqueTypes.roc

$ROC build ./examples/SortStrings/main.roc
$ROC ./examples/SortStrings/main.roc
expect ci_scripts/expect_scripts/SortStrings.exp

# these examples don't work on macos and aarch64 linux yet #225 #226 #231
if [[ "$(uname)" == "Linux" && "$(uname -m)" == "x86_64" ]]; then
  $ROC build --lib ./examples/GoPlatform/main.roc --output examples/GoPlatform/platform/libapp.so
  go build -C examples/GoPlatform/platform -buildmode=pie -o dynhost

  $ROC preprocess-host ./examples/GoPlatform/platform/dynhost ./examples/GoPlatform/platform/main.roc ./examples/GoPlatform/platform/libapp.so
  $ROC build ./examples/GoPlatform/main.roc

  # temporarily allow failure of lsb_release in case it is not installed
  set +e
  os_info=$(lsb_release -a 2>/dev/null)
  set -e

  # Skip Go tests if os is Ubuntu and we're not inside nix. This avoids a segfault on CI. See https://github.com/roc-lang/examples/issues/164
  if echo "$os_info" | grep -q "Ubuntu" && [ -z "${IN_NIX_SHELL}" ]; then
      echo "Skipping Go test due to https://github.com/roc-lang/examples/issues/164"
  else
      echo "Running Go test..."
      expect ci_scripts/expect_scripts/GoPlatform.exp
  fi


  $ROC build ./examples/DotNetPlatform/main.roc --lib --output ./examples/DotNetPlatform/platform/interop
  expect ci_scripts/expect_scripts/DotNetPlatform.exp
fi

echo "All tests passed!"
