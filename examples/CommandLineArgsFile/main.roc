# Run with `roc ./examples/CommandLineArgsFile/main.roc -- examples/CommandLineArgsFile/input.txt`
app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
}

import cli.Stdout
import cli.Path exposing [Path]
import cli.Arg exposing [Arg]

main! : List Arg => Result {} _
main! = |raw_args|

    # read all command line arguments
    args = List.map(raw_args, Arg.display)

    # get the second argument, the first is the executable's path
    arg_result = List.get(args, 1) |> Result.map_err(ZeroArgsGiven)

    when arg_result is
        Ok(arg) ->
            file_content_str = read_file_to_str!(Path.from_str(arg))?

            Stdout.line!("file content: ${file_content_str}")

        Err(ZeroArgsGiven(_)) ->
            Err(Exit(1, "Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- path/to/input.txt`"))

# reads a file and puts all lines in one Str
read_file_to_str! : Path => Result Str [ReadFileErr Str]_
read_file_to_str! = |path|

    path
    |> Path.read_utf8!
    |> Result.map_err(
        |file_read_err|
            path_str = Path.display(path)

            when file_read_err is
                FileReadErr(_, read_err) ->
                    ReadFileErr("Failed to read file:\n\t${path_str}\nWith error:\n\t${Inspect.to_str(read_err)}")

                FileReadUtf8Err(_, _) ->
                    ReadFileErr("I could not read the file:\n\t${path_str}\nIt contains charcaters that are not valid UTF-8:\n\t- Check if the file is encoded using a different format and convert it to UTF-8.\n\t- Check if the file is corrupted.\n\t- Find the characters that are not valid UTF-8 and fix or remove them."),
    )
