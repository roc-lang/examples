app "task-usage"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.1/Icc3xJoIixF3hCcfXrDwLCu4wQHtNdPyoJkEbkgIElA.tar.br",
    }
    imports [pf.Stdin, pf.Stdout, pf.Stderr, pf.Task.{ Task }]
    provides [main] to pf

main =
    run |> Task.onErr handleErr

run =
    total <- Task.loop 0 addNumberFromStdinT |> Task.await
    Stdout.line "Total: \(Num.toStr total)"

addNumberFromStdinT = \total ->
    line <- Stdin.line |> Task.await
    when addNumberFromStdin total line is
        Ok stepOrDone -> Task.ok stepOrDone
        Err err -> Task.err err

addNumberFromStdin = \total, line ->
    when line is
        Input text ->
            when Str.toI32 text is
                Ok num -> Ok (Step (total + num))
                Err InvalidNumStr -> Err (InvalidNumToAdd text total)

        End -> Ok (Done total)

handleErr = \err ->
    errorMsg =
        when err is
            InvalidNumToAdd text total -> "\"\(text)\" is not a valid number string. Interrupted at a total of \(Num.toStr total)."

    Stderr.line "Error: \(errorMsg)"

# Test when a valid line is read from stdin
expect addNumberFromStdin 1 (Input "123") == Ok (Step 124)

# Test when no more input is available
expect addNumberFromStdin 124 End == Ok (Done 124)

# Test when an invalid line is read from stdin
expect addNumberFromStdin 1 (Input "something else") == Err (InvalidNumToAdd "something else" 1)
