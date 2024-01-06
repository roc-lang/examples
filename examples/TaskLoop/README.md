# Task.loop

## Explanation

Sometimes, you need to repeat a task, or a chain of tasks, multiple times until a paticular event occurs. In roc, you can use `Task.loop` to do this.

The example process one by one a series of numbers read from stdin as lines of text until the input is finised (Ctrl-D or end of file).

It also stops if the input is not a valid number.

The example makes use of the [basic-cli platform](https://github.com/roc-lang/basic-cli) platform.

`Task.loop` starts from an initial state and send it to a function that is supposed to return a new chain of `Task`s. If the final task is a `Task.ok (Step newState)` then the loop continues with a new call of the same function. If the final task is a `Task.ok (Done finalState)` then the loop stops and returns final state. And if the final task is a `Task.err err`, then the loop stops and returns the error.

## Task.loop example

```roc
file:main.roc
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
