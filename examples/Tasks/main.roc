app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.13.0/nW9yMRtZuCYf1Oa9vbE5XoirMwzLbtoSgv7NGhUlqYA.tar.br",
}

import pf.Stdout
import pf.Stderr
import pf.Arg
import pf.Env
import pf.Http
import pf.Dir
import pf.Utc
import pf.Path exposing [Path]
import pf.Task exposing [Task]

main : Task {} _
main = run |> Task.onErr handleErr

run : Task {} _
run =

    # Get time since [Unix Epoch](https://en.wikipedia.org/wiki/Unix_time)
    startTime = Utc.now!

    # Read the HELLO environment variable
    helloEnvVar =
        readEnvVar "HELLO"
            |> Task.map! \msg -> if Str.isEmpty msg then "was empty" else "was set to $(msg)"
    Stdout.line! "HELLO env var $(helloEnvVar)"

    # Read command line arguments
    { url, outputPath } = readArgs!
    Stdout.line! "Fetching content from $(url)..."

    # Fetch the provided url using HTTP
    strHTML = fetchHtml! url
    Stdout.line! "Saving url HTML to $(Path.display outputPath)..."
    # Write HTML string to a file
    Path.writeUtf8 outputPath strHTML
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

readArgs : Task { url : Str, outputPath : Path } [FailedToReadArgs]_
readArgs =
    when Arg.list! {} is
        [_, first, second, ..] ->
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
    Dir.list "."
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
