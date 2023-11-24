# Tasks

The aim of this example is to demonstrate how to use `Task` with the [basic-cli platform](https://github.com/roc-lang/basic-cli). It includes various ways to use `Task` to perform common tasks such as reading command line arguments and environment variables, writing files, and fetching content using HTTP.

You may find the [tutorial](https://www.roc-lang.org/tutorial#tasks) or documentation for the [platform](https://www.roc-lang.org/packages/basic-cli/Task) useful as a guide with this example.

## Code

This is the example code. You will find detailed explanations for each of these tasks included below.

```roc
file:main.roc
```

## `Task` Explanation

These explanations are in the order that the code appears in the example, and should describe how `Task` is being used in this part of the example.

### Platform Main and Error Handling

The [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli) platform expects the application to provide a `main` function which performs various tasks in sequence and finally resolves to a `Task {} *` value. This is the main task that is ran by the platform when the application is executed.

```roc
main : Task {} *
main = run |> Task.onErr handleErr

# Error : [ UnableToReadArgs, UnableToReadDbgEnv Str, ... ]

handleErr : Error -> Task {} *

run : Task {} Error
```

The `run` function provides a `Task {} Error` which resolves to a success value of an empty record, and if any of the tasks in the sequence fail, it returns an application `Error`.  

This simplifies error handling by enabling all of the application errors to be handled using a single function `handleErr`.

### Read Coordinated Universal Time (UTC) epoch

The `Utc.now : Task Utc *` function returns a `Task` which will resolves with the current epoch time. It cannot fail and so returns a wildcard `*` type. 

**Aside** it may seem confusing that a `*` in the return position tells us that this task cannot fail. However, one way to think about this, is that it is impossible to write a function that can return *any* type, therefore this task must always succeed.

```roc
# Read UTC epoch
start <- Utc.now |> Task.await
```

### Read an environment variable

```roc
debug <- readDbgEnv "DEBUG" |> Task.await
```

### Debug print to stdout

```roc
{} <- printDebug debug "DEBUG variable set to verbose" |> Task.await
```

### Read command line arguments

```roc
{url, path} <- readUrlArg |> Task.await
```

### Fetch a website using HTTP

```roc
content <- fetchHtml url |> Task.await
```

### Write to a file

```roc
{} <- 
    File.writeUtf8 path content 
    |> Task.onErr \_ -> Task.err (UnableToWriteFile path)
    |> Task.await
```

### List the contents of a directory

```roc
{} <- 
    listCwd 
    |> Task.map \paths -> paths |> List.map Path.display |> Str.joinWith ","
    |> Task.await \files -> printDebug debug "Files in current directory: \(files)"
    |> Task.await 
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
