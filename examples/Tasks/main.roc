app "task-usage"
    packages { 
        pf: "../../../basic-cli/platform/main.roc"
    }
    imports [ pf.Stdout, pf.Stderr, pf.Arg, pf.Env, pf.Http, pf.Dir, pf.Utc, pf.File, pf.Path.{ Path }, pf.Task.{ Task } ]
    provides [ main ] to pf

main : Task {} _
main = run |> Task.onErr handleErr

run : Task {} _
run =

    # Get time since [Unix Epoch](https://en.wikipedia.org/wiki/Unix_time)
    startTime = Utc.now!

    # Read the HELLO environment variable
    helloEnvVarStateStr = 
        readEnvVar "HELLO"
        |> Task.map! \envVarStr ->
            if Str.isEmpty envVarStr then
                "HELLO env var was empty."
            else
                "HELLO env var was set to $(envVarStr)."

    Stdout.line! helloEnvVarStateStr
    
    # Read command line arguments
    { url, outputPath } = readArgs!

    Stdout.line! "Fetching content from $(url)..."
    
    # Fetch the provided url using HTTP
    strHTML = fetchHtml! url

    Stdout.line! "Saving url HTML to $(Path.display outputPath)..."

    # Write HTML string to a file
    File.writeUtf8 outputPath strHTML
    |> Task.onErr! \_ -> Task.err (FailedToWriteFile outputPath)

    # Print contents of current working directory
    listCwdContent
    |> Task.map \dirContents ->
        List.map dirContents Path.display
        |> Str.joinWith ","
    |> Task.await! \contentsStr ->
        Stdout.line "Contents of current directory: $(contentsStr)"
    
    endTime = Utc.now!
    runTime = Utc.deltaAsMillis startTime endTime |> Num.toStr

    Stdout.line! "Run time: $(runTime) ms"

    # Final task doesn't need to be awaited
    Stdout.line! "Done"

# NOTE in the future the trailing underscore `_` character will not be necessary.
# This is a temporary workaround until [this issue](https://github.com/roc-lang/roc/issues/5660) 
# is resolved.

readArgs : Task { url: Str, outputPath: Path } [FailedToReadArgs]_
readArgs =
    when Arg.list! is
        [ _, first, second, .. ] ->
            Task.ok { url: first, outputPath: Path.fromStr second }
        _ ->
            Task.err FailedToReadArgs

readEnvVar : Str -> Task Str []_
readEnvVar = \envVarName ->
    when Env.var envVarName |> Task.result! is
        Ok envVarStr if !(Str.isEmpty envVarStr) ->
            Task.ok envVarStr
        _ ->
            Task.ok ""

fetchHtml : Str -> Task Str [FailedToFetchHtml _]_
fetchHtml = \url ->
    { Http.defaultRequest & url } 
    |> Http.send 
    |> Task.await \resp -> resp |> Http.handleStringResponse |> Task.fromResult
    |> Task.mapErr FailedToFetchHtml

listCwdContent : Task (List Path) [FailedToListCwd]_
listCwdContent = 
    Path.fromStr "."
    |> Dir.list
    |> Task.onErr \_ -> Task.err FailedToListCwd

handleErr : _ -> Task {} _
handleErr = \err ->
    usage = "HELLO=1 roc main.roc -- \"https://www.roc-lang.org\" roc.html"

    errorMsg = 
        when err is
            FailedToReadArgs -> "Failed to read command line arguments, usage: $(usage)"
            FailedToFetchHtml httpErr -> "Failed to fetch URL $(Inspect.toStr httpErr), usage: $(usage)"
            FailedToWriteFile path -> "Failed to write to file $(Path.display path), usage: $(usage)"
            FailedToListCwd -> "Failed to list contents of current directory, usage: $(usage)"
            _ -> Inspect.toStr err

    Stderr.line! "Error: $(errorMsg)"
