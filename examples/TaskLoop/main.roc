app "task-usage"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.1/Icc3xJoIixF3hCcfXrDwLCu4wQHtNdPyoJkEbkgIElA.tar.br",
    }
    imports [pf.Stdin, pf.Stdout, pf.Stderr, pf.Task.{ Task }]
    provides [main] to pf

main =
    run |> Task.onErr handleErr

run =
    # Start the loop of tasks defined by `addNumberFromStdin`. The initial state, the total, is 0.
    # `total` will be set with the final step of the loop, when `addNumberFromStdin` returns `Task.ok (Done total)`
    total <- Task.loop 0 addNumberFromStdin |> Task.await
    Stdout.line "Total: \(Num.toStr total)"

# This function read from stdin and return one of the three possible values:
# `Task.ok (Step aNewState)`: To inform Task.loop that a new Step has been completed with a new state.
# `Task.ok (Done aFinalState)`: To inform Task.loop that the loop is done with a final state. No new steps will be executed.
# `Task.err error`: To inform Task.loop that an error has occurred, in this case an unprocessable input, and the loop should be stopped.
addNumberFromStdin = \total ->
    # Read a line from stdin
    line <- Stdin.line |> Task.await
    when line is
        # If a line has been read from stdin
        Input text ->
            # Try to concert to a number
            when Str.toI32 text is
                # It is a valid number, return the completted `Step` with the new state, total + num
                Ok num -> Task.ok (Step (total + num))
                # The text cannot be concerted to a number, return a Task.err.
                # `Task.loop` will return with error
                Err InvalidNumStr -> Task.err (ErrorInvalidNumStr text)

        # No more content in stdin, inform `Task.loop` that the loop is done with a final total.
        End -> Task.ok (Done total)

handleErr = \err ->
    errorMsg =
        when err is
            ErrorInvalidNumStr str -> "\"\(str)\" is not a valid number string"

    Stderr.line "Error: \(errorMsg)"
