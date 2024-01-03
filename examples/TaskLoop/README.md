# Task.loop

## Explanation

Somtimes, you need to repeat a task, or a chain of tasks, multiple times until a paticular event occurs. In roc, you can use `Task.loop` to do this.

This example shows how to do it.

The example process one by one a series of numbers inputed via stdin as lines of text until the input is finised (Ctrl-D or end of file).




This example shows how to use `Task` with the [basic-cli platform](https://github.com/roc-lang/basic-cli). We'll explain how tasks work while demonstrating how to read command line arguments and environment variables, write files, and fetch content through HTTP.

We recommend you read the [tasks and backpassings sections in the tutorial](https://www.roc-lang.org/tutorial#tasks) first and open up the [documentation for the basic-cli platform](https://www.roc-lang.org/packages/basic-cli/Task) on the side.

Remember; a Task represents an [effect](https://en.wikipedia.org/wiki/Side_effect_(computer_science)); an interaction with state outside your Roc program, such as the terminal's standard output, or a file.

Below we'll introduce the example code step by step, you can check out the full code at any time at the bottom.

### main

The [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli) platform requires an application to provide a Task, namely `main : Task {} *`. This task usually represents a sequence or combination of `Tasks`, and will resolve to an empty record `{}`. This is similar to `void` or `unit` in other programming languages.

The `main` task is run by the platform when the application is executed. It cannot return errors, which is indicated by the `*`.

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

The `run : Task {} Error` task resolves to a success value of an empty record, and if it fails, returns with our custom `Error` type.  

This simplifies error handling so that a single `handleErr` function can be used to handle all the `Error` values that could occur.

### run

We want to see how fast our app runs, so we'll start our `run` `Task` by getting the current time.

```roc
startTime <- Utc.now |> Task.await
```

To get the current time, we need to interact with state outside of the roc program.
We can not just calculate the current time, so we use a task, `Utc.now`.
It's type is `Task Utc *`. The task resolves to the [UTC time](https://en.wikipedia.org/wiki/Coordinated_Universal_Time) (since [Epoch](https://en.wikipedia.org/wiki/Unix_time)). `Task.await` allows us to chain tasks. We use this common [backpassing pattern](https://www.roc-lang.org/tutorial#backpassing) `... <- ... |> ...`  to make it look similar to `startTime = Utc.now` for readability.

#### Read an environment variable

Next up in the task chain we'll read the environment variable `HELLO`:

```roc
helloEnvVar <- readEnvVar "HELLO" |> Task.await

# …

readEnvVar : Str -> Task Str *
```
And print it (to [stdout](https://en.wikipedia.org/wiki/Standard_streams)):

```roc
{} <- Stdout.line "HELLO env var was set to \(helloEnvVar)" |> Task.await
```

The `{} <- ` looks different then the previous steps of the chain, that's because the type of `Stdout.line` is `Str -> Task {} *`. The `Task` resolves to nothing (= the empty record) upon success.
You can't just do `Stdout.line "HELLO env var was set to \(helloEnvVar)"` without `{} <- ... |> Task.await` like you could in other languages. By keeping it in the task chain we know which roc code is pure (no [side-effects](https://en.wikipedia.org/wiki/Side_effect_(computer_science))) and which isn't, which comes with [a lot of benefits](https://chat.openai.com/share/8cff0cbb-a4a3-4b4f-9ddf-8824ac5809ec)!


### Command line arguments


When reading command line arguments, it's nice to be able to read multiple arguments. We can use [record destructuring](https://www.roc-lang.org/tutorial#record-destructuring) to fit these multiple arguments nicely in our chain:

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

Next up, we'll write our strHTML to a file located at `outputPath`.

```roc
{} <- 
    File.writeUtf8 outputPath strHTML
    |> Task.onErr \_ -> Task.err (FailedToWriteFile outputPath)
    |> Task.await
```

The `File.writeUtf8` task resolves to an empty record if the provided `Str` is sucessfully written, so we're using `{} <-` again.
The error type for `writeUtf8` is `[FileWriteErr Path WriteErr]` but we'd like to replace it with our own simpler error here. For that we use `Task.onErr`.

### List the contents of a directory

We're going to finish up with something more involved:

```roc
    {} <- 
        listCwdContent
        |> Task.map \dirContents ->
            List.map dirContents Path.display
            |> Str.joinWith ","

        |> Task.await \contentsStr ->
            Stdout.line "Contents of current directory: \(contentsStr)"

        |> Task.await 

# …

listCwdContent : Task (List Path) [FailedToListCwd]_
```

We call `listCwdContent` to list all files and folders in the current directory.
Next, we take this list of paths, turn them all into `Str` using `Path.display`, and join/concatenate this list with a ",".
We use `Task.map` to transform the success value of a `Task` into something that is not a `Task`, a `Str` in this case.
Take a minute to look at the similarities and differences of `Task.map` and `Task.await`:

```roc
Task.map : Task a b, (a -> c) -> Task c b

Task.await : Task a b, (a -> Task c b) -> Task c b
```

Next, we write our `Str` of combined `dirContents` to `Stdout`. We use `Task.await` because we're passing it a function that returns a `Task` with `Stdout.line`.

We end with `|> Task.await` to complete the typical backpassing pattern.

### Feedback

Tasks are important in roc, we'd love to hear how we can further improve this example. Get in touch on our [group chat](https://roc.zulipchat.com) or [create an issue](https://github.com/roc-lang/examples/issues).

## Full Code

```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```sh
$ HELLO=1 roc examples/Tasks/main.roc -- "https://www.roc-lang.org" roc.html
HELLO env var was set to 1
Fetching content from https://www.roc-lang.org...
Saving url HTML to roc.html...
Contents of current directory: [...]
Run time: 329 ms
Done
```

