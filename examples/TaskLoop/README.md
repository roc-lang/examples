# Task.loop

Sometimes, you need to repeat a task, or a chain of tasks, multiple times until a particular event occurs. In roc, you can use `Task.loop` to do this.

We'll demonstrate this by processing a series of numbers read from stdin line by line until the end of input (Ctrl-D or [end of file](https://en.wikipedia.org/wiki/End-of-file)).

The loop will also end if the input is not a valid number.

`Task.loop` starts from an initial state and sends it to a provided function that will return a new Task.
- If this new Task matches `Task.ok (Step newState)` then the loop continues with a new call of the same function, now using `newState`.
- If it's of the form `Task.ok (Done finalState)` then the loop stops and returns `finalState`.
- If the Task is a `Task.err err`, then the loop stops and returns the error.

### main

The [roc-lang/basic-cli](https://github.com/roc-lang/basic-cli) platform requires an application to provide a Task, namely `main : Task {} *`.

In this case, the task is provided by the `run` function.

The function may return an error, so we send it to the `handlerErr``.

```roc
main =
    run |> Task.onErr handleErr
```

### run

In `run` the main Task is started with `Task.loop`.

The loop of tasks is defined by `addNumberFromStdinT`. 

The initial state, the total, is 0.

`total` will be set with the final step of the loop, when `addNumberFromStdinT` returns `Task.ok (Done total)`

```roc
run =
    total <- Task.loop 0 addNumberFromStdinT |> Task.await
    Stdout.line "Total: \(Num.toStr total)"
```

### addNumberFromStdinT

This function read a from stdin a line and return one of the following Tasks:

- `Task.ok (Step aNewState)`: To inform Task.loop that a new Step has been completed with a new state.
- `Task.ok (Done aFinalState)`: To inform Task.loop that the loop is done with a final state. No new steps will be executed.
- `Task.err error`: To inform Task.loop that an error has occurred, in this case an unprocessable input. The loop should stop.

It calls `addNumberFromStdin` to process the input and return the three possible results. Then this fuction wraps them into a `Task.ok` or `Task.err` task.

``` roc
addNumberFromStdinT = \total ->
    line <- Stdin.line |> Task.await
    when addNumberFromStdin total line is
        Ok stepOrDone -> Task.ok stepOrDone
        Err err -> Task.err err
```

### addNumberFromStdin

This function process the input.

If some input is avaliable, it tries to convert into a `I32`. If the conversion succeeds, it returns `Ok (Step (total + num)`. A new step can be start later with a new total.

If it fails, it return an error. The loop needs to stop.

If there is no more input, it returns `Ok (Done total)`. The loop needs to stop as well.

```roc
addNumberFromStdin = \total, line ->
    when line is
        Input text ->
            when Str.toI32 text is
                Ok num -> Ok (Step (total + num))
                Err InvalidNumStr -> Err (InvalidNumToAdd text total)

        End -> Ok (Done total)
```

### handleErr

Funally, this fucntion will return a Task that prints the error message.

```roc
handleErr = \err ->
    errorMsg =
        when err is
            InvalidNumToAdd text total -> "\"\(text)\" is not a valid number string. Interrupted at a total of \(Num.toStr total)."

    Stderr.line "Error: \(errorMsg)"
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc run main.roc < numbers.txt 

Total: 178
```

The total is the sum of all the numbers in `numbers.txt`:

```text
file:numbers.txt
```

Now, let's try with a file that contain an invalid line:

```
$ roc run main.roc < numbers-invalid.txt 

Error: "Something else" is not a valid number string. Interrupted at a total of 201.
```

You can see the invalid line in the `numbers-invalid.txt` file:

```text
file:numbers-invalid.txt
```
