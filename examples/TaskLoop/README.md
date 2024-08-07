# Looping Tasks

Sometimes, you need to repeat a task, or a chain of tasks, multiple times until a particular event occurs. In roc, you can use `Task.loop` to do this.

We'll demonstrate this by adding numbers read from stdin until the end of input (Ctrl-D or [end of file](https://en.wikipedia.org/wiki/End-of-file)).

`Task.loop` starts from an initial state and sends it to a provided function that will return a new Task.
- If this new Task matches `Task.ok (Step newState)` then the loop continues with a new call of the same function, now using `newState`.
- If the Task is of the form `Task.ok (Done finalState)` then the loop stops and returns `finalState`.
- If the Task is a `Task.err err`, then the loop stops and returns the error.

## Code step by step

```roc
Task.loop 0 addNumberFromStdin
```
We provide `loop` with:
- our initial state; the number 0
- a function that can ingest a number and return a Task; `addNumberFromStdin`

This function takes our current sum total, reads a line from stdin and returns one of the following:

- `Task.ok (Step newSum)` 
- `Task.ok (Done finalSum)` on Ctrl-D or [end of file](https://en.wikipedia.org/wiki/End-of-file).
- `Task.err (NotNum Str)` if something other than a number was provided to stdin.

Take a moment to match this behavior with the type signature of `addNumberFromStdin`:
```roc
I64 -> Task [Done I64, Step I64] [NotNum Str]
```

This is where the action happens:
```roc
addNumberFromStdin = \sum ->
    input = Stdin.line!

    addResult =
        when input is
            Input text ->
                when Str.toI64 text is
                    Ok num ->
                        Ok (Step (sum + num))

                    Err InvalidNumStr ->
                        Err (NotNum text)

            End -> Ok (Done sum)

    Task.fromResult addResult
```

## Full Code

```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc < numbers.txt 
Enter some numbers on different lines, then press Ctrl-D to sum them up.
Sum: 178
```
