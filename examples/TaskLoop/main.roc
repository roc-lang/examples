app [main!] {
    pf: platform "../../../basic-cli/platform/main.roc",
}

import pf.Stdin
import pf.Stdout
import pf.Stderr

main! = \_ ->
    when run! {} is
        Ok {} -> Ok {}
        Err err -> print_err! err

run! : {} => Result {} _
run! = \_ ->
    try Stdout.line! "Enter some numbers on different lines, then press Ctrl-D to sum them up."

    sum = try add_number_from_stdin! 0

    Stdout.line! "Sum: $(Num.toStr sum)"

add_number_from_stdin! : I64 => Result I64 _
add_number_from_stdin! = \sum ->
    when Stdin.line! {} is
        Ok input ->
            when Str.toI64 input is
                Ok num -> add_number_from_stdin! (sum + num)
                Err _ -> Err (NotNum input)

        Err EndOfFile -> Ok sum
        Err err -> err |> Inspect.toStr |> NotNum |> Err

print_err! : _ => Result {} _
print_err! = \err ->
    when err is
        NotNum text -> Stderr.line! "Error: \"$(text)\" is not a valid I64 number."
        _ -> Stderr.line! "Error: $(Inspect.toStr err)"
