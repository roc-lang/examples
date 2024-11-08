# Run with `roc ./examples/CommandLineArgsFile/main.roc -- examples/CommandLineArgsFile/input.txt`
# This currently does not work in combination with --linker=legacy, see https://github.com/roc-lang/basic-cli/issues/82
app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.16.0/O00IPk-Krg_diNS2dVWlI0ZQP794Vctxzv0ha96mK0E.tar.br",
}

import pf.Stdout
import pf.Path exposing [Path]
import pf.Arg

main =
    # read all command line arguments
    args = Arg.list! {} # {} is necessary as a temporary workaround

    # get the second argument, the first is the executable's path
    argResult = List.get args 1 |> Result.mapErr (\_ -> ZeroArgsGiven)

    when argResult is
        Ok arg ->
            fileContentStr = readFileToStr! (Path.fromStr arg)

            Stdout.line! "file content: $(fileContentStr)"

        Err ZeroArgsGiven ->
            Task.err (Exit 1 "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- path/to/input.txt`")

# reads a file and puts all lines in one Str
readFileToStr : Path -> Task Str [ReadFileErr Str]_
readFileToStr = \path ->

    path
    |> Path.readUtf8
    |> Task.mapErr # Make a nice error message
        (\fileReadErr ->
            pathStr = Path.display path

            when fileReadErr is
                FileReadErr _ readErr ->
                    readErrStr = Inspect.toStr readErr

                    ReadFileErr "Failed to read file:\n\t$(pathStr)\nWith error:\n\t$(readErrStr)"

                FileReadUtf8Err _ _ ->
                    ReadFileErr "I could not read the file:\n\t$(pathStr)\nIt contains charcaters that are not valid UTF-8:\n\t- Check if the file is encoded using a different format and convert it to UTF-8.\n\t- Check if the file is corrupted.\n\t- Find the characters that are not valid UTF-8 and fix or remove them."
        )
