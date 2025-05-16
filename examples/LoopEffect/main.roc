app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
}

import cli.Stdin
import cli.Stdout
import cli.Stderr
import cli.Arg exposing [Arg]

main! : List Arg => Result {} _
main! = |_args|
    when run!({}) is
        Ok({}) -> Ok({})
        Err(err) -> print_err!(err)

run! : {} => Result {} _
run! = |_|
    Stdout.line!("Enter some numbers on different lines, then press Ctrl-D to sum them up.")?

    sum = add_number_from_stdin!(0)?

    Stdout.line!("Sum: ${Num.to_str(sum)}")

## recursive function that sums every number that is provided through stdin
add_number_from_stdin! : I64 => Result I64 _
add_number_from_stdin! = |sum|
    when Stdin.line!({}) is
        Ok(input) ->
            when Str.to_i64(input) is
                Ok(num) -> add_number_from_stdin!((sum + num))
                Err(_) -> Err(NotNum(input))

        Err(EndOfFile) -> Ok(sum)
        Err(err) -> err |> Inspect.to_str |> NotNum |> Err

print_err! : _ => Result {} _
print_err! = |err|
    when err is
        NotNum(text) -> Stderr.line!("Error: \"${text}\" is not a valid I64 number.")
        _ -> Stderr.line!("Error: ${Inspect.to_str(err)}")
