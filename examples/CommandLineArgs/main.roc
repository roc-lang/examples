# Run this with `roc dev aoc-2020/01.roc -- aoc-2020/input/01.txt`
app "command-line-args"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br",
    }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.File,
        pf.Path,
        pf.Task,
        pf.Arg,
    ]
    provides [main] to pf

# Define custom error to return from our tasks, this makes it easier to handle
# errors that may come from multiple sources.
TaskError : [InvalidArg, InvalidFile Str]

# Define the main task, this is the entry point for the program. Note that all
# possible errors are handled hence the return value is {} and possible errors
# are [].
main : Task.Task {} []
main =
    # Run the effectful myTask, which may fail
    result <- Task.attempt myTask

    # Handle the result or errors
    when result is
        Ok answer -> Stdout.line answer
        Err InvalidArg -> Stderr.line "Error: expected arg file.roc -- path/to/input.txt"
        Err (InvalidFile path) -> Stderr.line "Error: couldn't read input file at \"\(path)\""

# Define a task that reads a file path from command line arguments,
# reads the file into a RocStr and then return a formatted string.
myTask : Task.Task Str TaskError
myTask =
    path <- readPath |> Task.await
    fileContents <- readFile path |> Task.await

    Task.succeed "Success, file contents: \(fileContents)"

# This task returns a Str or a TaskError, the Str will the argument passed on
# the command line, e.g. `roc run main.roc -- path/to/input.txt`
# returns the string "path/to/input.txt"
readPath : Task.Task Str TaskError
readPath =
    # Read command line arguments
    Arg.list
    |> Task.mapFail \_ -> InvalidArg
    |> Task.await \args ->
        # Get the second argument, the first is the executable location
        List.get args 1
        |> Result.mapErr \_ -> InvalidArg
        |> Task.fromResult

# This task returns a Str or a TaskError, the Str will the contents of the file
# that is located at the path given.
readFile : Str -> Task.Task Str TaskError
readFile = \path ->
    # Read input file at the given path
    Path.fromStr path
    |> File.readUtf8
    |> Task.mapFail \_ -> InvalidFile path
