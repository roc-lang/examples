app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
}

import cli.Stdout
import cli.Arg exposing [Arg]
import cli.Env
import cli.Http
import cli.Dir
import cli.Utc exposing [Utc]
import cli.Path exposing [Path]

usage = "HELLO=1 roc main.roc -- \"https://www.roc-lang.org\" roc.html"

main! : List Arg => Result {} _
main! = |args|
    run!(args)
    |> Result.map_err(
        |err|
            Exit(1, "Error: ${make_error_msg(err)}\n\nExample usage: ${usage}"),
    )

run! : List Arg => Result {} _
run! = |args|

    # Get time since [Unix Epoch](https://en.wikipedia.org/wiki/Unix_time)
    start_time : Utc
    start_time = Utc.now!({}) # We use {} because effects need to be functions.

    # Read the HELLO environment variable
    hello_env : Str
    hello_env =
        read_env_var!("HELLO")?

    Stdout.line!("HELLO env var was set to ${hello_env}.")?

    # Read command line arguments
    { url, output_path } = parse_args!(args)?

    Stdout.line!("Fetching content from ${url}...")?

    # Fetch the provided url using HTTP
    html_str : Str
    html_str = fetch_html!(url)?

    Stdout.line!("Saving HTML to ${Path.display(output_path)}...")?

    # Write HTML string to a file
    Path.write_utf8!(html_str, output_path) ? |err| FailedToWriteFile(Path.display(output_path), err)

    # Print contents of current working directory
    cwd_contents = list_cwd_contents!({})?

    Stdout.line!("Contents of current directory: ${cwd_contents}")?

    end_time : Utc
    end_time = Utc.now!({})

    run_duration = Utc.delta_as_millis(start_time, end_time)

    Stdout.line!("Run time: ${Num.to_str(run_duration)} ms")?

    Stdout.line!("Done")

parse_args! : List Arg => Result { url : Str, output_path : Path } _
parse_args! = |args|
    when List.map(args, Arg.display) is
        [_, first, second, ..] ->
            Ok({ url: first, output_path: Path.from_str(second) })

        bad_args ->
            Err(FailedToReadArgs(bad_args))

read_env_var! : Str => Result Str [VarNotFound Str, EnvVarSetEmpty Str]
read_env_var! = |env_var_name|
    when Env.var!(env_var_name) is
        Ok(env_var_str) ->
            if Str.is_empty(env_var_str) then
                Err(EnvVarSetEmpty(env_var_name))
            else
                Ok(env_var_str)

        err -> err

fetch_html! : Str => Result Str _
fetch_html! = |url|
    Http.get_utf8!(url)
    |> Result.map_err(
        |err| FailedToFetchHtml(url, err),
    )

# effects need to be functions, so we use the empty input type `{}`
list_cwd_contents! : {} => Result Str [FailedToListCwd _]
list_cwd_contents! = |_|

    dir_contents =
        Dir.list!(".") ? |err| FailedToListCwd(err)

    contents_str =
        dir_contents
        |> List.map(Path.display)
        |> Str.join_with(",")

    Ok(contents_str)

# In a professional application, it's recommended to use error tags throughout your program and
# convert them into user-friendly messages (in the user's language) at the application's edge.
make_error_msg : _ -> Str
make_error_msg = |error|
    when error is
        FailedToReadArgs(bad_args) ->
            """
            Failed to read command line arguments, I received: ${Inspect.to_str(bad_args)}
            """

        VarNotFound(var_name) ->
            """
            Environment variable '${var_name}' was not found.
            Set the variable before running the application.
            """

        EnvVarSetEmpty(var_name) ->
            """
            Environment variable '${var_name}' was empty.
            Provide a non-empty value for this variable.
            """

        FailedToFetchHtml(url, err) ->
            """
            Failed to fetch HTML content for URL: ${url}

            Error: ${Inspect.to_str(err)}

            Check the URL and your internet connection.
            """

        FailedToWriteFile(path_str, err) ->
            """
            Failed to write file: ${path_str}

            Error: ${Inspect.to_str(err)}
            """

        FailedToListCwd(err) ->
            """
            Failed to list current directory contents of current directory.
            Error: ${Inspect.to_str(err)}
            """

        other ->
            "An unexpected error occurred: ${Inspect.to_str(other)}"
