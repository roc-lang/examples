app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
}

import pf.Stdout
import pf.Arg exposing [Arg]
import pf.Env
import pf.Http
import pf.Dir
import pf.Utc exposing [Utc]
import pf.Path exposing [Path]

usage = "HELLO=1 roc main.roc -- \"https://www.roc-lang.org\" roc.html"

main! : List Arg => Result {} _
main! = \args ->

    # Get time since [Unix Epoch](https://en.wikipedia.org/wiki/Unix_time)
    start_time : Utc
    start_time = Utc.now! {}

    # Read the HELLO environment variable
    hello_env : Str
    hello_env =
        read_env_var! "HELLO"
        |> try
        |> \msg -> if Str.isEmpty msg then "was empty" else "was set to $(msg)"

    try Stdout.line! "HELLO env var $(hello_env)"

    # Read command line arguments
    { url, output_path } = try parse_args! args

    try Stdout.line! "Fetching content from $(url)..."

    # Fetch the provided url using HTTP
    html_str : Str
    html_str = try fetch_html! url

    try Stdout.line! "Saving url HTML to $(Path.display output_path)..."

    # Write HTML string to a file
    Path.write_utf8! html_str output_path
    |> Result.mapErr \_ -> FailedToWriteFile "Failed to write to file $(Path.display output_path), usage: $(usage)"
    |> try

    # Print contents of current working directory
    try list_cwd_contents! {}

    end_time : Utc
    end_time = Utc.now! {}

    run_duration = Utc.delta_as_millis start_time end_time

    try Stdout.line! "Run time: $(Num.toStr run_duration) ms"

    try Stdout.line! "Done"

    Ok {}

parse_args! : List Arg => Result { url : Str, output_path : Path } _
parse_args! = \args ->
    when List.map args Arg.display is
        [_, first, second, ..] ->
            Ok { url: first, output_path: Path.from_str second }

        _ ->
            Err (FailedToReadArgs "Failed to read command line arguments, usage: $(usage)")

read_env_var! : Str => Result Str []
read_env_var! = \envVarName ->
    when Env.var! envVarName is
        Ok envVarStr if !(Str.isEmpty envVarStr) -> Ok envVarStr
        _ -> Ok ""

fetch_html! : Str => Result Str _
fetch_html! = \url ->
    Http.get_utf8! url
    |> Result.mapErr \err -> FailedToFetchHtml "Failed to fetch URL $(Inspect.toStr err), usage: $(usage)"

list_cwd_contents! : {} => Result {} _
list_cwd_contents! = \_ ->

    dirContents =
        Dir.list! "."
        |> Result.mapErr \_ -> FailedToListCwd "Failed to list contents of current directory, usage: $(usage)"
        |> try

    contentsStr = List.map dirContents Path.display |> Str.joinWith ","

    Stdout.line! "Contents of current directory: $(contentsStr)"
