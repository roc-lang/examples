# Run with `roc ./examples/CommandLineArgs/main.roc some_argument`
# !! This currently does not work in combination with --linker=legacy, see https://github.com/roc-lang/basic-cli/issues/82
app [main!] {
    pf: platform "../../../basic-cli/platform/main.roc",
}

import pf.Stdout
import pf.Arg

main! = \raw_args ->
    args = List.map raw_args Arg.display

    # get the second argument, the first is the executable's path
    arg_result = List.get args 1 |> Result.mapErr (\_ -> ZeroArgsGiven)

    when arg_result is
        Err ZeroArgsGiven ->
            Err (Exit 1 "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- input.txt`")

        Ok first_argument ->
        Stdout.line! "received argument: $(first_argument)"
