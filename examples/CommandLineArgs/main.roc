# Run with `roc ./examples/CommandLineArgs/main.roc some_argument`
# !! This currently does not work in combination with --linker=legacy, see https://github.com/roc-lang/basic-cli/issues/82
app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.13.0/zsDHOdxyAcj6EhyNZx_3qhIICVlnho-OZ5X2lFDLi0k.tar.br",
}

import pf.Stdout
import pf.Task
import pf.Arg

main =
    args = Arg.list! {} # {} is necessary as a temporary workaround

    # get the second argument, the first is the executable's path
    argResult = List.get args 1 |> Result.mapErr (\_ -> ZeroArgsGiven)

    when argResult is
        Err ZeroArgsGiven ->
            Task.err (Exit 1 "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- input.txt`")

        Ok firstArgument ->
            Stdout.line "received argument: $(firstArgument)"
