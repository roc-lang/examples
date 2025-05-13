app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import cli.Arg exposing [Arg]

main! : List Arg => Result {} _
main! = |raw_args|

    args : { a : I32, b : I32 }
    args = read_args(raw_args)?

    result =
        [
            ("sum", args.a + args.b),
            ("difference", args.a - args.b),
            ("product", args.a * args.b),
            ("integer quotient", args.a // args.b),
            ("remainder", args.a % args.b),
            ("exponentiation", Num.pow_int(args.a, args.b)),
        ]
        |> List.map(
            |(operation, answer)| "${operation}: ${Num.to_str(answer)}",
        )
        |> Str.join_with("\n")

    Stdout.line!(result)

## Reads two command-line arguments, attempts to parse them as `I32` numbers,
## and returns a [`Result`](https://www.roc-lang.org/builtins/Result).
##
## On success, the [`Result`](https://www.roc-lang.org/builtins/Result)
## will contain a record with two fields, `a` and `b`, holding the parsed `I32` values.
##
## This will fail if an argument is missing, if there's an issue with parsing
## the arguments as `I32` numbers, or if the parsed numbers are outside the
## expected range (-1000 to 1000). Then the [`Result`](https://www.roc-lang.org/builtins/Result) will contain
## an `Exit I32 Str` error.
read_args : List Arg -> Result { a : I32, b : I32 } [Exit I32 Str]
read_args = |raw_args|
    arg_range_min = -1000
    arg_range_max = 1000
    expected_nr_of_args = 2 + 1 # +1 because first will be name or path of the program

    arg_range_min_str = Inspect.to_str(arg_range_min)
    arg_range_max_str = Inspect.to_str(arg_range_max)
    # TODO this function should not use Exit for modularity. Only perform this change after static dispatch has landed!
    invalid_args = Exit(1, "Error: Please provide two integers between ${arg_range_min_str} and ${arg_range_max_str} as arguments.")
    invalid_num_str = Exit(1, "Error: Invalid number format. Please provide integers between ${arg_range_min_str} and ${arg_range_max_str}.")

    args =
        if List.len(raw_args) != expected_nr_of_args then
            return Err(invalid_args)
        else
            List.map(raw_args, Arg.display)

    a_result = List.get(args, 1) |> Result.try(Str.to_i32)
    b_result = List.get(args, 2) |> Result.try(Str.to_i32)

    when (a_result, b_result) is
        (Ok(a), Ok(b)) ->
            if a < arg_range_min or a > arg_range_max or b < arg_range_min or b > arg_range_max then
                Err(invalid_num_str)
            else
                Ok({ a, b })

        _ -> Err(invalid_num_str)
