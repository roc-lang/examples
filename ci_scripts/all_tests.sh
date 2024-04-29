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

$ROC build ./examples/EncodeDecode/main.roc
expect ci_scripts/expect_scripts/EncodeDecode.exp