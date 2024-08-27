app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.14.0/dC5ceT962N_4jmoyoffVdphJ_4GlW3YMhAPyGPr-nU0.tar.br" }

import pf.Stdout
import pf.Task
import pf.Arg

TaskErrors : [InvalidArg, InvalidNumStr]

main =
    task =
        args = readArgs!

        formatResult = \(operation, result) ->
            resultStr = Num.toStr result

            "$(operation): $(resultStr)"

        results =
            [
                ("sum", args.a + args.b),
                ("difference", args.a - args.b),
                ("product", args.a * args.b),
                ("integer quotient", args.a // args.b),
                ("remainder", args.a % args.b),
                ("exponentiation", Num.powInt args.a args.b),
            ]
            |> List.map formatResult
            |> Str.joinWith "\n"

        Task.ok results

    when Task.result! task is
        Ok result -> Stdout.line result
        Err InvalidArg -> Task.err (Exit 1 "Error: Please provide two integers between -1000 and 1000 as arguments.")
        Err InvalidNumStr -> Task.err (Exit 1 "Error: Invalid number format. Please provide integers between -1000 and 1000.")

## Reads two command-line arguments, attempts to parse them as `I32` numbers,
## and returns a task containing a record with two fields, `a` and `b`, holding
## the parsed `I32` values.
##
## If the arguments are missing, if there's an issue with parsing the arguments
## as `I32` numbers, or if the parsed numbers are outside the expected range
## (-1000 to 1000), the function will return a task that fails with an
## error `InvalidArg` or `InvalidNumStr`.
readArgs : Task.Task { a : I32, b : I32 } TaskErrors
readArgs =

    args =
        Arg.list {}
            |> Task.mapErr! \_ -> InvalidArg

    aResult = List.get args 1 |> Result.try Str.toI32
    bResult = List.get args 2 |> Result.try Str.toI32

    when (aResult, bResult) is
        (Ok a, Ok b) ->
            if a < -1000 || a > 1000 || b < -1000 || b > 1000 then
                Task.err InvalidNumStr
            else
                Task.ok { a, b }

        _ -> Task.err InvalidNumStr
