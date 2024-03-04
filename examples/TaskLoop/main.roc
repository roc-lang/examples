app "task-usage"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br",
    }
    imports [pf.Stdin, pf.Stdout, pf.Stderr, pf.Task.{ Task }]
    provides [main] to pf

run : Task {} [NotNum Str]
run =
    {} <- Stdout.line "Enter some numbers on different lines, then press Ctrl-D to sum them up." |> Task.await
    sum <- Task.loop 0 addNumberFromStdin |> Task.await

    Stdout.line "Sum: $(Num.toStr sum)"

addNumberFromStdin : I64 -> Task [Done I64, Step I64] [NotNum Str]
addNumberFromStdin = \sum ->
    input <- Stdin.line |> Task.await

    addResult =
        when input is
            Input text ->
                when Str.toI64 text is
                    Ok num ->
                        Ok (Step (sum + num))

                    Err InvalidNumStr ->
                        Err (NotNum text)

            End ->
                Ok (Done sum)

    Task.fromResult addResult

main =
    run |> Task.onErr printErr

printErr : [NotNum Str] -> Task {} *
printErr = \err ->
    errorMsg =
        when err is
            NotNum text -> "\"$(text)\" is not a valid I64 number."

    Stderr.line "Error: $(errorMsg)"
