# Tasks

## Explanation

This example shows how to use `Task` with the [basic-cli platform](https://github.com/roc-lang/basic-cli). We'll explain how tasks work while demonstrating how to read command line arguments and environment variables, write files, and fetch content through HTTP.

We recommend you read the [tasks and backpassings sections in the tutorial](https://www.roc-lang.org/tutorial#tasks) first and open up the [documentation for the basic-cli platform](https://www.roc-lang.org/packages/basic-cli/Task) on the side.

Reminder: a Task represents an [effect](https://en.wikipedia.org/wiki/Side_effect_(computer_science)); an interaction with state outside your Roc program, such as the terminal's standard output, or a file.

Below we'll introduce the example code step by step, you can check out the full code at any time at the bottom.

### main

The [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli) platform requires an application to provide a Task, namely `main : Task {} *`. This task usually represents a sequence or combination of `Tasks`, and will resolve to an empty record `{}`.

The `main` task is run by the platform when the application is executed. It cannot return errors, which is indicated by the wildcard `*`.

For this example, we'll be using the following main:
```roc
main : Task {} *
main =
    run
    |> Task.onErr handleErr

# Error : [ FailedToReadArgs, FailedToFetchHtml Str, ... ]

handleErr : Error -> Task {} *

run : Task {} Error
```

The `run : Task {} Error` task resolves to a success value of an empty record, and if it fails, returns with our `Error` type.  

This simplifies error handling so that a single `handleErr` function can be used to handle all the `Error` values that could occur.

### run

We want to see how fast our app runs, so we'll start our run `Task` by getting the current time.

```roc
startTime <- Utc.now |> Task.await
```

To get the current time, we need to interact with state outside of the roc program.
We can not just calculate the current time, so we use the task `Utc.now`.
It's type is `Task Utc *`. The task resolves to the [UTC time](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) (since [Epoch](https://en.wikipedia.org/wiki/Unix_time)). `Task.await` allows us to chain tasks. We use this common [backpassing pattern](https://www.roc-lang.org/tutorial#backpassing) `... <- ... |> ...`  to make it look similar to `startTime = Utc.now` for readability.

#### Read an environment variable

Next up in the task chain we'll read the environment variable HELLO:

```roc
helloEnvVar <- readEnvVar "HELLO" |> Task.await

# …

readEnvVar : Str -> Task Str *
```
And print it (to [stdout](https://en.wikipedia.org/wiki/Standard_streams)):

```roc
{} <- Stdout.line "HELLO env var was set to \(helloEnvVar)" |> Task.await
```

The `{} <- ` looks different then the previous steps of the chain, that's because the type of `Stdout.line` is `Str -> Task {} *`. The `Task` resolves to nothing (= the empty record) upon success. This is similar to `void` or `unit` in other programming languages.
You can't just do `Stdout.line "HELLO env var was set to \(helloEnvVar)"` without `{} <- ... |> Task.await` like you could in other languages. By keeping it in the task chain we know which roc code is pure (no [side-effects](https://en.wikipedia.org/wiki/Side_effect_(computer_science))) and which isn't, which comes with [a lot of benefits](https://chat.openai.com/share/8cff0cbb-a4a3-4b4f-9ddf-8824ac5809ec)!


### Command line arguments


When reading command line arguments, it's nice to be able to return multiple things. We can use [record destructuring](https://www.roc-lang.org/tutorial#record-destructuring) to fit this nicely into our chain:

```roc
{ url, outputPath } <- readArgs |> Task.await

# …

readArgs : Task { url: Str, outputPath: Path } [FailedToReadArgs]_
```

Notice that `readArgs` can actually return an error unlike the previous tasks, namely `FailedToReadArgs`.
With our `Task.await` chain we can deal with errors at the end so it doesn't interrupt the flow of our code right now.

The underscore (`_`) at the end of `[FailedToReadArgs]` is a temporary workaround for [an issue](https://github.com/roc-lang/roc/issues/5660).

### Fetch website content

We'll use the `url` we obtained in the previous step and retrieve its contents:

```roc
strHTML <- fetchHtml url |> Task.await
```

### Write to a file

The `File.writeUtf8` task resolves to an empty record if the `contents` are sucessfully written to the `path`, or it fails with a `FileWriteErr` tag. Using `Task.onErr` any error value is transformed into an `UnableToWriteFile` tag.

```roc
{} <- 
    File.writeUtf8 path content 
    |> Task.onErr \_ -> Task.err (UnableToWriteFile path)
    |> Task.await
```

### List the contents of a directory

The `listCwd` task resolves to a `List Path` with the contents of the current directory, or fails with an `UnableToReadCwd` tag. The `paths` are then mapped to `Str` values, joined with a comma separator, and optionally printed to stdout.  

```roc
{} <- 
    listCwd 
    |> Task.map \paths -> paths |> List.map Path.display |> Str.joinWith ","
    |> Task.await \files -> printDebug debug "Files in current directory: \(files)"
    |> Task.await

# …

listCwd : Task (List Path) [UnableToReadCwd]_
```

## Full Code

```roc
file:main.roc
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

