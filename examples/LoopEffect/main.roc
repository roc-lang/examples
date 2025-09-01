app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
}

import cli.Stdin
import cli.Stdout
import cli.Arg exposing [Arg]

## recursive function that sums every number that is provided through stdin
add_number_from_stdin! : I64 => Result I64 _
add_number_from_stdin! = |sum|
    when Stdin.line!({}) is
        Ok(input) ->
            num = Str.to_i64(input) ? |_| NotNum(input)
            add_number_from_stdin!((sum + num))

        Err(EndOfFile) -> Ok(sum)
        Err(err) -> Err(NotNum(Inspect.to_str(err)))


run! : {} => Result {} _
run! = |_|
    Stdout.line!("Enter some numbers on different lines, then press Ctrl-D to sum them up.")?

    sum = add_number_from_stdin!(0)?

    Stdout.line!("Sum: ${Num.to_str(sum)}")

    
main! : List Arg => Result {} _
main! = |_args|
    when run!({}) is
        Ok({}) -> Ok({})

        Err(NotNum(text)) ->
            Err(Exit(1, "Error: \"${text}\" is not a valid I64 number."))

        Err(err) ->
            Err(Exit(1, "Error: ${Inspect.to_str(err)}"))
