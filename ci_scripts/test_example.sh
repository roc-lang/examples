#!/usr/bin/env bash

# Tests one example with the Roc version that it pins in its header.
# Usage: ./ci_scripts/test_example.sh HelloWorld
# Exits with code 3 if the example is not tested yet.
#
# Set the ROC environment variable to use that roc binary instead of the pinned nightly, e.g.
#   ROC=/home/username/gitrepos/roc/zig-out/bin/roc ./ci_scripts/test_example.sh HelloWorld

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -exo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: test_example.sh EXAMPLE_NAME" >&2
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")/.."

readonly name="$1"

# Exit code of an example that is not tested yet, this is not a failure.
readonly skipped_exit_code=3

if [ ! -d "examples/$name" ]; then
  echo "ERROR: examples/$name does not exist." >&2
  exit 1
fi

# Examples without code have no Roc version to pin.
if [ "$name" = "MultiLineComments" ]; then
  echo "$name has no code to test"
  exit 0
fi

if [ -n "${ROC:-}" ]; then
  roc="$ROC"
else
  roc="$(./ci_scripts/get_roc.sh "$(./ci_scripts/example_roc_version.sh "examples/$name")")"
fi

# build_example [roc build flags], builds main.roc of the example in its directory
build_example() {
  (cd "examples/$name" && "$roc" build --no-cache "$@" main.roc)
}

run_expect() {
  expect "ci_scripts/expect_scripts/$name.exp"
}

case "$name" in
  AdvancedParsing)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  AllSyntax)
    build_example --opt=dev
    run_expect
    ;;
  BasicDict)
    "$roc" test --no-cache examples/BasicDict/BasicDict.roc
    ;;
  CommandLineArgs | CommandLineArgsFile | Commands | EncodeDecode | ErrorHandlingRealWorld | \
    HelloWorld | ImportFromDirectory | ImportPackageFromModule | IngestFiles | Json | LeastSquares | \
    LoopEffect | MultipleRocFiles | RandomNumbers | Tuples)
    build_example
    run_expect
    ;;
  CustomInspect)
    "$roc" test --no-cache examples/CustomInspect/OpaqueTypes.roc
    ;;
  CustomLiterals)
    "$roc" test --no-cache examples/CustomLiterals/main.roc
    ;;
  ErrorHandlingBasic)
    "$roc" test --no-cache examples/ErrorHandlingBasic/ErrorHandlingBasic.roc
    ;;
  FizzBuzz | Parser | SafeMath | Snake | TryOperatorDesugaring)
    build_example
    "$roc" test --no-cache "examples/$name/main.roc"
    run_expect
    ;;
  GraphTraversal)
    "$roc" test --no-cache examples/GraphTraversal/Graph.roc
    ;;
  NestedTypes)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  OpenRecords)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  NominalTypes)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  Paths)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  PatternAliases)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  Loops)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  PatternMatching)
    "$roc" test --no-cache examples/PatternMatching/PatternMatching.roc
    ;;
  Polymorphism)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  RecordBuilder)
    "$roc" test --no-cache examples/RecordBuilder/DateParser.roc
    ;;
  RocRay)
    case "$(uname -s)-$(uname -m)" in
      Linux-aarch64 | Linux-arm64)
        # RocRay 0.10.0 does not ship a Linux ARM64 host.
        "$roc" check --no-cache "examples/$name/main.roc"
        ;;
      *)
        build_example
        "./examples/$name/main" --host-headless --host-headless-frames=3
        ;;
    esac
    ;;
  Streams)
    build_example
    "$roc" test --no-cache "examples/$name/main.roc"
    run_expect
    ;;
  RecursiveTypes)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  Sets)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  StringPatterns)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  TowersOfHanoi)
    "$roc" test --no-cache examples/TowersOfHanoi/Hanoi.roc
    ;;
  Unicode)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  WrappingArithmetic)
    "$roc" test --no-cache "examples/$name/main.roc"
    ;;
  # TODO: also run these, the expect scripts need updating
  ElmWebApp)
    "$roc" check --no-cache examples/ElmWebApp/backend.roc
    ;;
  HelloWeb)
    "$roc" check --no-cache examples/HelloWeb/main.roc
    ;;
  # TODO: migrate this example to the new syntax
  SortStrings)
    echo "Skipping $name"
    exit "$skipped_exit_code"
    ;;
  *)
    echo "ERROR: no tests are defined for examples/$name, add them to ci_scripts/test_example.sh" >&2
    exit 1
    ;;
esac

echo "$name passed!"
