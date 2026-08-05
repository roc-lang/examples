#!/usr/bin/env bash

# #https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
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

cd ./examples/HelloWorld/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/HelloWorld.exp

cd ./examples/FizzBuzz/
$ROC build --no-cache main.roc
cd ../..
$ROC test ./examples/FizzBuzz/main.roc
expect ci_scripts/expect_scripts/FizzBuzz.exp

$ROC test ./examples/GraphTraversal/Graph.roc

cd ./examples/Json/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/Json.exp

cd ./examples/LeastSquares/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/LeastSquares.exp

cd ./examples/IngestFiles/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/IngestFiles.exp

cd ./examples/Parser/
$ROC build --no-cache main.roc
cd ../..
$ROC test ./examples/Parser/main.roc
expect ci_scripts/expect_scripts/Parser.exp

$ROC test ./examples/PatternMatching/PatternMatching.roc

cd ./examples/AllSyntax/
$ROC build --no-cache --opt=dev main.roc
cd ../..
expect ci_scripts/expect_scripts/AllSyntax.exp

cd ./examples/RandomNumbers/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/RandomNumbers.exp

cd ./examples/CommandLineArgs/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/CommandLineArgs.exp

cd ./examples/Commands/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/Commands.exp

cd ./examples/CommandLineArgsFile/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/CommandLineArgsFile.exp

cd ./examples/TryOperatorDesugaring/
$ROC build --no-cache main.roc
cd ../..
$ROC test ./examples/TryOperatorDesugaring/main.roc
expect ci_scripts/expect_scripts/TryOperatorDesugaring.exp

cd ./examples/Tuples/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/Tuples.exp

$ROC test ./examples/TowersOfHanoi/Hanoi.roc

$ROC test ./examples/ErrorHandlingBasic/ErrorHandlingBasic.roc

cd ./examples/ErrorHandlingRealWorld/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/ErrorHandlingRealWorld.exp

cd ./examples/LoopEffect/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/LoopEffect.exp

cd ./examples/Snake/
$ROC build --no-cache main.roc
cd ../..
$ROC test ./examples/Snake/main.roc
expect ci_scripts/expect_scripts/Snake.exp

$ROC test ./examples/RecordBuilder/DateParser.roc

$ROC test ./examples/BasicDict/BasicDict.roc

cd ./examples/MultipleRocFiles/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/MultipleRocFiles.exp

cd ./examples/ImportFromDirectory/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/ImportFromDirectory.exp

cd ./examples/EncodeDecode/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/EncodeDecode.exp

cd ./examples/SafeMath/
$ROC build --no-cache main.roc
cd ../..
$ROC test ./examples/SafeMath/main.roc
expect ci_scripts/expect_scripts/SafeMath.exp

cd ./examples/HelloWeb/
#$ROC build --no-cache main.roc
cd ../..
#expect ci_scripts/expect_scripts/HelloWeb.exp

cd ./examples/ImportPackageFromModule/
$ROC build --no-cache main.roc
cd ../..
expect ci_scripts/expect_scripts/ImportPackageFromModule.exp

$ROC test ./examples/CustomInspect/OpaqueTypes.roc

cd ./examples/SortStrings/
#$ROC build --no-cache main.roc
cd ../..
#$ROC ./examples/SortStrings/main.roc
#expect ci_scripts/expect_scripts/SortStrings.exp

#TODO: add ElmWebApp

echo "All tests passed!"
