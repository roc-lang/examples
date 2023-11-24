app "task-usage"
    packages { 
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.6.1/LFXCmL8ahcPM6oFkV9gcZwthvHFxF1OS_vz92lQYrI4.tar.br",
        colors: "https://github.com/lukewilliamboswell/roc-ansi-escapes/releases/download/0.1.1/cPHdNPNh8bjOrlOgfSaGBJDz6VleQwsPdW0LJK6dbGQ.tar.br",
    }
    imports [ pf.Stdout, pf.Stderr, pf.Arg, pf.Env, pf.Http, pf.Dir, pf.Utc, pf.File, pf.Path.{ Path }, pf.Task.{ Task }, colors.Color ]
    provides [ main ] to pf

# NOTE in future there will be no requirement for a trailing underscore `_` character 
# for the Task error tag union. This is a temporary workaround until [this issue](https://github.com/roc-lang/roc/issues/5660) 
# is resolved.

main : Task {} *
main = run |> Task.onErr handleErr

Error : [
    UnableToReadArgs,
    UnableToFetchHtml Str,
    UnableToWriteFile Path,
    UnableToReadCwd,
]

handleErr : Error -> Task {} *
handleErr = \err ->
    usage = "DEBUG=1 roc main.roc -- \"https://www.roc-lang.org\" roc.html"
    msg = when err is
        UnableToReadArgs -> "Unable to read command line arguments, usage: \(usage)"
        UnableToFetchHtml httpErr -> "Unable to fetch URL \(httpErr), usage: \(usage)"
        UnableToWriteFile path -> "Unable to write file \(Path.display path), usage: \(usage)"
        UnableToReadCwd -> "Unable to read current working directory, usage: \(usage)"

    [ Color.fg "ERROR:" Red, msg ] |> Str.joinWith " " |> Stderr.line

run : Task {} Error
run =

    # Read UTC epoch
    start <- Utc.now |> Task.await

    # Read an environment variable
    debug <- readDbgEnv "DEBUG" |> Task.await

    # Debug print to stdout
    {} <- printDebug debug "DEBUG variable set to verbose" |> Task.await
    
    # Read command line arguments
    { url, path } <- readUrlArg |> Task.await

    # Debug print to stdout
    {} <- printDebug debug "Fetching content from \(url)..." |> Task.await
    
    # Fetch a website using HTTP
    content <- fetchHtml url |> Task.await

    # Debug print to stdout
    {} <- printDebug debug "Saving content to \(Path.display path)..." |> Task.await

    # Write to a file
    {} <- 
        File.writeUtf8 path content 
        |> Task.onErr \_ -> Task.err (UnableToWriteFile path)
        |> Task.await

    # List the contents of cwd directory
    {} <- 
        listCwd 
        |> Task.map \paths -> paths |> List.map Path.display |> Str.joinWith ","
        |> Task.await \files -> printDebug debug "Files in current directory: \(files)"
        |> Task.await 
    
    # Read UTC epoch
    end <- Utc.now |> Task.await
    duration = start |> Utc.deltaAsMillis end |> Num.toStr

    # Final task doesn't need to be awaited
    when debug is
        DebugSet -> printDebug debug "Completed in \(duration)ms"
        DebugNotSet -> Stdout.line "Completed"

readUrlArg : Task { url: Str, path: Path } [UnableToReadArgs]_
readUrlArg =
    args <- Arg.list |> Task.attempt
    
    when args is
        Ok ([ _, first, second, .. ]) -> Task.ok { url: first, path: Path.fromStr second }
        _ -> Task.err UnableToReadArgs

readDbgEnv : Str -> Task [DebugSet, DebugNotSet] *
readDbgEnv = \var ->
    result <- Env.var var |> Task.attempt

    when result is
        Ok value if !(Str.isEmpty value) -> Task.ok DebugSet
        _ -> Task.ok DebugNotSet

printDebug : [DebugSet, DebugNotSet], Str -> Task {} *
printDebug = \debug, msg ->
    when debug is
        DebugSet -> [ Color.fg "INFO:" Green, msg ] |> Str.joinWith " " |> Stdout.line
        DebugNotSet -> Task.ok {}

fetchHtml : Str -> Task Str [UnableToFetchHtml Str]_
fetchHtml = \url ->
    { Http.defaultRequest & url } 
    |> Http.send 
    |> Task.onErr \err -> Task.err (UnableToFetchHtml (Http.errorToString err)) 

listCwd : Task (List Path) [UnableToReadCwd]_
listCwd = 
    Path.fromStr "."
    |> Dir.list
    |> Task.onErr \_ -> Task.err UnableToReadCwd