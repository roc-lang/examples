app "task-usage"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br"
    }
    imports [ pf.Stdout, pf.Stderr, pf.Arg, pf.Env, pf.Http, pf.Dir, pf.Utc, pf.File, pf.Path.{ Path }, pf.Task.{ Task } ]
    provides [ main ] to pf

run : Task {} Error
run =

    # Get time since [Unix Epoch](https://en.wikipedia.org/wiki/Unix_time)
    startTime <- Utc.now |> Task.await

    # Read the HELLO environment variable
    helloEnvVar <- readEnvVar "HELLO" |> Task.await

    {} <- Stdout.line "HELLO env var was set to $(helloEnvVar)" |> Task.await
    
    # Read command line arguments
    { url, outputPath } <- readArgs |> Task.await

    {} <- Stdout.line "Fetching content from $(url)..." |> Task.await
    
    # Fetch the provided url using HTTP
    strHTML <- fetchHtml url |> Task.await

    {} <- Stdout.line "Saving url HTML to $(Path.display outputPath)..." |> Task.await

    # Write HTML string to a file
    {} <- 
       File.writeUtf8 outputPath strHTML
       |> Task.onErr \_ -> Task.err (FailedToWriteFile outputPath)
       |> Task.await

    # Print contents of current working directory
    {} <- 
        listCwdContent
        |> Task.map \dirContents ->
            List.map dirContents Path.display
            |> Str.joinWith ","

        |> Task.await \contentsStr ->
            Stdout.line "Contents of current directory: $(contentsStr)"

        |> Task.await 
    
    endTime <- Utc.now |> Task.await
    runTime = Utc.deltaAsMillis startTime endTime |> Num.toStr

    {} <- Stdout.line "Run time: $(runTime) ms" |> Task.await

    # Final task doesn't need to be awaited
    Stdout.line "Done"

# NOTE in the future the trailing underscore `_` character will not be necessary.
# This is a temporary workaround until [this issue](https://github.com/roc-lang/roc/issues/5660) 
# is resolved.

readArgs : Task { url: Str, outputPath: Path } [FailedToReadArgs]_
readArgs =
    args <- Arg.list |> Task.attempt
    
    when args is
        Ok ([ _, first, second, .. ]) ->
            Task.ok { url: first, outputPath: Path.fromStr second }
        _ ->
            Task.err FailedToReadArgs

readEnvVar : Str -> Task Str *
readEnvVar = \envVarName ->
    envVarResult <- Env.var envVarName |> Task.attempt

    when envVarResult is
        Ok envVarStr if !(Str.isEmpty envVarStr) ->
            Task.ok envVarStr
        _ ->
            Task.ok ""

fetchHtml : Str -> Task Str [FailedToFetchHtml Str]_
fetchHtml = \url ->
    { Http.defaultRequest & url } 
    |> Http.send 
    |> Task.onErr \err ->
        Task.err (FailedToFetchHtml (Http.errorToString err)) 

listCwdContent : Task (List Path) [FailedToListCwd]_
listCwdContent = 
    Path.fromStr "."
    |> Dir.list
    |> Task.onErr \_ -> Task.err FailedToListCwd

main : Task {} *
main =
    run
    |> Task.onErr handleErr

Error : [
    FailedToReadArgs,
    FailedToFetchHtml Str,
    FailedToWriteFile Path,
    FailedToListCwd,
]

handleErr : Error -> Task {} *
handleErr = \err ->
    usage = "HELLO=1 roc main.roc -- \"https://www.roc-lang.org\" roc.html"

    errorMsg = when err is
        FailedToReadArgs -> "Failed to read command line arguments, usage: $(usage)"
        FailedToFetchHtml httpErr -> "Failed to fetch URL $(httpErr), usage: $(usage)"
        FailedToWriteFile path -> "Failed to write to file $(Path.display path), usage: $(usage)"
        FailedToListCwd -> "Failed to list contents of current directory, usage: $(usage)"

    Stderr.line "Error: $(errorMsg)"
