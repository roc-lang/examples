# Run with `roc ./examples/CommandLineArgs/main.roc some_argument`
app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
}

import cli.Stdout
import cli.Arg exposing [Arg]

main! : List Arg => Result {} _
main! = |raw_args|
    args = List.map(raw_args, Arg.display)

    # get the second argument, the first is the executable's path
    arg_result = List.get(args, 1) |> Result.map_err(ZeroArgsGiven)

    when arg_result is
        Err(ZeroArgsGiven(_)) ->
            Err(Exit(1, "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- input.txt`"))

        Ok(first_argument) ->
            Stdout.line!("received argument: ${first_argument}")
