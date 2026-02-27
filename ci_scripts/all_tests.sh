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

# opt-in list of examples to test (add examples as they are updated for the new compiler)
optin=(
  "TryOperatorDesugaring"
)

is_optin() {
  local name="$1"
  for entry in "${optin[@]}"; do
    if [[ "$entry" == "$name" ]]; then
      return 0
    fi
  done
  return 1
}

if is_optin "HelloWorld"; then
  $ROC build ./examples/HelloWorld/main.roc
  expect ci_scripts/expect_scripts/HelloWorld.exp
fi

if is_optin "FizzBuzz"; then
  $ROC build ./examples/FizzBuzz/main.roc
  $ROC test ./examples/FizzBuzz/main.roc
  expect ci_scripts/expect_scripts/FizzBuzz.exp
fi

if is_optin "GraphTraversal"; then
  $ROC test ./examples/GraphTraversal/Graph.roc
fi

if is_optin "Json"; then
  $ROC build ./examples/Json/main.roc --linker=legacy
  expect ci_scripts/expect_scripts/Json.exp
fi

if is_optin "LeastSquares"; then
  $ROC build ./examples/LeastSquares/main.roc
  expect ci_scripts/expect_scripts/LeastSquares.exp
fi

if is_optin "IngestFiles"; then
  $ROC build ./examples/IngestFiles/main.roc
  expect ci_scripts/expect_scripts/IngestFiles.exp
fi

if is_optin "Parser"; then
  $ROC build ./examples/Parser/main.roc
  $ROC test ./examples/Parser/main.roc
  expect ci_scripts/expect_scripts/Parser.exp
fi

if is_optin "PatternMatching"; then
  $ROC test ./examples/PatternMatching/PatternMatching.roc
fi

if is_optin "AllSyntax"; then
  $ROC build ./examples/AllSyntax/main.roc
  expect ci_scripts/expect_scripts/AllSyntax.exp
fi

if is_optin "RandomNumbers"; then
  $ROC build ./examples/RandomNumbers/main.roc
  expect ci_scripts/expect_scripts/RandomNumbers.exp
fi

if is_optin "CommandLineArgs"; then
  $ROC build ./examples/CommandLineArgs/main.roc
  expect ci_scripts/expect_scripts/CommandLineArgs.exp
fi

if is_optin "Commands"; then
  $ROC build ./examples/Commands/main.roc
  expect ci_scripts/expect_scripts/Commands.exp
fi

if is_optin "CommandLineArgsFile"; then
  $ROC build ./examples/CommandLineArgsFile/main.roc
  expect ci_scripts/expect_scripts/CommandLineArgsFile.exp
fi

if is_optin "TryOperatorDesugaring"; then
  $ROC build ./examples/TryOperatorDesugaring/main.roc
  $ROC test ./examples/TryOperatorDesugaring/main.roc
  expect ci_scripts/expect_scripts/TryOperatorDesugaring.exp
fi

if is_optin "Tuples"; then
  $ROC build ./examples/Tuples/main.roc
  expect ci_scripts/expect_scripts/Tuples.exp
fi

if is_optin "TowersOfHanoi"; then
  $ROC test ./examples/TowersOfHanoi/Hanoi.roc
fi

if is_optin "ErrorHandlingBasic"; then
  $ROC test ./examples/ErrorHandlingBasic/ErrorHandlingBasic.roc
fi

if is_optin "ErrorHandlingRealWorld"; then
  $ROC build ./examples/ErrorHandlingRealWorld/main.roc
  expect ci_scripts/expect_scripts/ErrorHandlingRealWorld.exp
fi

if is_optin "LoopEffect"; then
  $ROC build ./examples/LoopEffect/main.roc
  expect ci_scripts/expect_scripts/LoopEffect.exp
fi

if is_optin "Snake"; then
  $ROC build ./examples/Snake/main.roc
  $ROC test ./examples/Snake/main.roc
  expect ci_scripts/expect_scripts/Snake.exp
fi

if is_optin "RecordBuilder"; then
  $ROC test ./examples/RecordBuilder/DateParser.roc
fi

if is_optin "BasicDict"; then
  $ROC test ./examples/BasicDict/BasicDict.roc
fi

if is_optin "MultipleRocFiles"; then
  $ROC build ./examples/MultipleRocFiles/main.roc
  expect ci_scripts/expect_scripts/MultipleRocFiles.exp
fi

if is_optin "ImportFromDirectory"; then
  $ROC build ./examples/ImportFromDirectory/main.roc
  expect ci_scripts/expect_scripts/ImportFromDirectory.exp
fi

if is_optin "EncodeDecode"; then
  $ROC build ./examples/EncodeDecode/main.roc
  expect ci_scripts/expect_scripts/EncodeDecode.exp
fi

if is_optin "SafeMath"; then
  $ROC build ./examples/SafeMath/main.roc
  $ROC test ./examples/SafeMath/main.roc
  expect ci_scripts/expect_scripts/SafeMath.exp
fi

if is_optin "HelloWeb"; then
  $ROC build ./examples/HelloWeb/main.roc --linker=legacy
  expect ci_scripts/expect_scripts/HelloWeb.exp
fi

if is_optin "ImportPackageFromModule"; then
  $ROC build ./examples/ImportPackageFromModule/main.roc
  expect ci_scripts/expect_scripts/ImportPackageFromModule.exp
fi

if is_optin "CustomInspect"; then
  $ROC test ./examples/CustomInspect/OpaqueTypes.roc
fi

if is_optin "SortStrings"; then
  $ROC build ./examples/SortStrings/main.roc
  $ROC ./examples/SortStrings/main.roc
  expect ci_scripts/expect_scripts/SortStrings.exp
fi

# these examples don't work on macos and aarch64 linux yet #225 #226 #231
if [[ "$(uname)" == "Linux" && "$(uname -m)" == "x86_64" ]]; then
  if is_optin "GoPlatform"; then
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
  fi

  if is_optin "DotNetPlatform"; then
    $ROC build ./examples/DotNetPlatform/main.roc --lib --output ./examples/DotNetPlatform/platform/interop
    expect ci_scripts/expect_scripts/DotNetPlatform.exp
  fi
fi

echo "All tests passed!"
