app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.14.0/dC5ceT962N_4jmoyoffVdphJ_4GlW3YMhAPyGPr-nU0.tar.br",
}

import pf.Stdin
import pf.Stdout
import pf.Stderr
import pf.Task exposing [Task]

main = run |> Task.onErr printErr

run : Task {} _
run =
    Stdout.line! "Enter some numbers on different lines, then press Ctrl-D to sum them up."

    sum = Task.loop! 0 addNumberFromStdin
    Stdout.line! "Sum: $(Num.toStr sum)"

addNumberFromStdin : I64 -> Task [Done I64, Step I64] _
addNumberFromStdin = \sum ->
    when Stdin.line |> Task.result! is
        Ok input ->
            when Str.toI64 input is
                Ok num -> Task.ok (Step (sum + num))
                Err _ -> Task.err (NotNum input)

        Err (StdinErr EndOfFile) -> Task.ok (Done sum)
        Err err -> err |> Inspect.toStr |> NotNum |> Task.err

printErr : _ -> Task {} _
printErr = \err ->
    when err is
        NotNum text -> Stderr.line "Error: \"$(text)\" is not a valid I64 number."
        _ -> Stderr.line "Error: $(Inspect.toStr err)"

