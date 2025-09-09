# Run with `roc ./examples/CommandLineArgsFile/main.roc -- examples/CommandLineArgsFile/input.txt`
app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
}

import cli.Stdout
import cli.File
import cli.Arg exposing [Arg]

run! = |raw_args|
    # read all command line arguments
    args = List.map(raw_args, Arg.display)

    # get the second argument, the first is the executable's path
    first_arg =
        List.get(args, 1) ? |_| ZeroArgsGiven

    file_content_str = File.read_utf8!(first_arg) ? |err| FileReadFailed(first_arg, err)

    Stdout.line!("file content: ${file_content_str}")

main! : List Arg => Result {} _
main! = |raw_args|
    when run!(raw_args) is
        Ok(_) -> Ok({})
        Err(ZeroArgsGiven) ->
            Err(Exit(1, "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- input.txt`"))

        Err(FileReadFailed(first_arg, file_err)) ->
            Err(Exit(1, "Error FileReadFailed:\n\tI tried to read the file at path: `${first_arg}`\n\tBut I got this error: `${Inspect.to_str(file_err)}`"))

        Err(err) -> Err(err)

