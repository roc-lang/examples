app "task-usage"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.1/Icc3xJoIixF3hCcfXrDwLCu4wQHtNdPyoJkEbkgIElA.tar.br",
    }
    imports [pf.Stdin, pf.Stdout, pf.Stderr, pf.Task.{ Task }]
    provides [main] to pf

main =
    run |> Task.onErr handleErr

run =
    # Start the loop of tasks defined by `addNumberFromStdinT`. The initial state, the total, is 0.
    # `total` will be set with the final step of the loop, when `addNumberFromStdinT` returns `Task.ok (Done total)`
    total <- Task.loop 0 addNumberFromStdinT |> Task.await
    Stdout.line "Total: \(Num.toStr total)"

# This function read from stdin and return one of the following Tasks:
# `Task.ok (Step aNewState)`: To inform Task.loop that a new Step has been completed with a new state.
# `Task.ok (Done aFinalState)`: To inform Task.loop that the loop is done with a final state. No new steps will be executed.
# `Task.err error`: To inform Task.loop that an error has occurred, in this case an unprocessable input, and the loop should be stopped.
addNumberFromStdinT = \total ->
    # Read a line from stdin
    line <- Stdin.line |> Task.await
    # Use addNumberFromStdin to calculate the step
    when addNumberFromStdin total line is
        # The step has been completed or no further steps to execute
        Ok stepOrDone -> Task.ok stepOrDone
        # The inpput cannot be processed. `Task.loop` will return with error
        Err err -> Task.err err

# This function takes the current state, the total, and a line from stdin and return one of the three possible values
addNumberFromStdin = \total, line ->
    when line is
        # If a line has been read from stdin
        Input text ->
            # Try to concert to a number
            when Str.toI32 text is
                # It is a valid number, return the completted `Step` with the new state, total + num
                Ok num -> Ok (Step (total + num))
                # The text cannot be concerted to a number, return a Task.err.
                # `Task.loop` will return with error
                Err InvalidNumStr -> Err (ErrorInvalidNumStr text total)

        # No more content in stdin, inform `Task.loop` that the loop is done with a final total.
        End -> Ok (Done total)

handleErr = \err ->
    errorMsg =
        when err is
            ErrorInvalidNumStr text total -> "\"\(text)\" is not a valid number string. Interrupted at a total of \(Num.toStr total)."

    Stderr.line "Error: \(errorMsg)"

# Test when a valid line is read from stdin
expect addNumberFromStdin 1 (Input "123") == Ok (Step 124)

# Test when no more input is available
expect addNumberFromStdin 124 End == Ok (Done 124)

# Test when an invalid line is read from stdin
expect addNumberFromStdin 1 (Input "something else") == Err (ErrorInvalidNumStr "something else" 1)
