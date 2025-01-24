# Run with `roc ./examples/CommandLineArgs/main.roc some_argument`
app [main!] {
    cli: platform "../../../basic-cli/platform/main.roc",
}

import cli.Stdout
import cli.Arg

main! = |raw_args|
    args = List.map(raw_args, Arg.display)

    # get the second argument, the first is the executable's path
    arg_result = List.get(args, 1) |> Result.map_err(ZeroArgsGiven)

    when arg_result is
        Err(ZeroArgsGiven(_)) ->
            Err(Exit(1, "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- input.txt`"))

        Ok(first_argument) ->
            Stdout.line!("received argument: ${first_argument}")
