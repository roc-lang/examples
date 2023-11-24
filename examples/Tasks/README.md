# Tasks

The aim of this example is to demonstrate how to use `Task` with the [basic-cli platform](https://github.com/roc-lang/basic-cli). It includes various ways to use `Task` to perform common tasks such as reading command line arguments and environment variables, writing files, and fetching content using HTTP.

You may find the [tutorial](https://www.roc-lang.org/tutorial#tasks) or documentation for the [platform](https://www.roc-lang.org/packages/basic-cli/Task) useful as a guide with this example.

## Code

This is the example code. You will find detailed explanations for each of these tasks included below.

```roc
file:main.roc
```

## `Task` Explanation

These explanations are in the order they appears in the example, and focus on how `Task` is used in different ways to achieve the required outcome.

### Platform Main and Error Handling

The [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli) platform requires an application to provide a `main : Task {} *`. This task usually represents a sequence or combination of `Tasks`, and will resolve to an empty record.

The `main` task is run by the platform when the application is executed. It cannot fail, and therefore returns the wildcard `*` type.

**Aside** it may seem confusing that a `*` in the return position tells us that this task cannot fail. However, one way to think about this, is that it is impossible to write a function that can return *any* type, therefore this task must always succeed.

```roc
main : Task {} *
main = run |> Task.onErr handleErr

# Error : [ UnableToReadArgs, UnableToReadDbgEnv Str, ... ]

handleErr : Error -> Task {} *

run : Task {} Error
```

The `run : Task {} Error` task resolves to a success value of an empty record, and if it fails, returns with an application `Error`.  

This simplifies error handling so that a single `handleErr` function can be used to handle all the application `Error` values that could possibly occur.

### Read Coordinated Universal Time (UTC) epoch

The `Utc.now : Task Utc *` task resolves with the current `Utc` epoch time. We can simply use `Task.await` and bind the value to a variable using backpassing syntax, as we know that this task cannot fail. 

```roc
start <- Utc.now |> Task.await
```

### Read an environment variable

The `readDbgEnv` function takes a `Str` argument for environment variable, it cannot fail, and so will resolves to either a `DebugSet` or `DebugNotSet` value.

```roc
debug <- readDbgEnv "DEBUG" |> Task.await

# …

readDbgEnv : Str -> Task [DebugSet, DebugNotSet] *
```

### Debug print to stdout

The `printDebug` function takes a tag, either `DebugSet` or `DebugNotSet`, and a message `Str`. It returns a `Task` which will resolve to an empty record, and cannot fail.

```roc
{} <- printDebug debug "DEBUG variable set to verbose" |> Task.await

# …

printDebug : [DebugSet, DebugNotSet], Str -> Task {} *
```

### Read command line arguments

The `readUrlArg` function returns a `Task` which resolves to a record `{ url: Str, path: Path }`, or fails with an `UnableToReadArgs` tag.

```roc
{url, path} <- readUrlArg |> Task.await

# …

readUrlArg : Task { url: Str, path: Path } [UnableToReadArgs]_
```

### Fetch a website using HTTP

The `fetchHtml` function takes a `Str` argument for the URL to fetch, and returns a `Task` which will resolve to the content `Str` of the website, or fails with an `UnableToFetchHtml` tag.

```roc
content <- fetchHtml url |> Task.await

# …

fetchHtml : Str -> Task Str [UnableToFetchHtml Str]_
```

### Write to a file

The `File.writeUtf8` function returns a `Task` which will resolves to an empty record if the `contents` are sucessfuly written to the `path`, or it will fail with a `FileWriteErr` tag. Using `Task.onErr` this error is translated into an `UnableToWriteFile` tag.

```roc
{} <- 
    File.writeUtf8 path content 
    |> Task.onErr \_ -> Task.err (UnableToWriteFile path)
    |> Task.await
```

### List the contents of a directory

The `listCwd` function returns a `Task` which resolves to a `List Path` with the contents of the current directory, or it fails with an `UnableToReadCwd` tag. These `paths` are then mapped to `Str` vlues, joined with a comma separator, and printed to stdout.  

```roc
{} <- 
    listCwd 
    |> Task.map \paths -> paths |> List.map Path.display |> Str.joinWith ","
    |> Task.await \files -> printDebug debug "Files in current directory: \(files)"
    |> Task.await

# …

listCwd : Task (List Path) [UnableToReadCwd]_
```

## Output

Run this from the directory that has `main.roc` in it:

```sh
$ DEBUG=1 roc examples/Tasks/main.roc -- "http://roc-lang.org" roc.html
INFO: DEBUG variable set to verbose
INFO: Fetching content from http://roc-lang.org...
INFO: Saving content to roc.html...
INFO: Completed in 219ms
```
