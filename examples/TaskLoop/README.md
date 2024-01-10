# Task.loop

Sometimes, you need to repeat a task, or a chain of tasks, multiple times until a particular event occurs. In roc, you can use `Task.loop` to do this.

We'll demonstrate this by processing a series of numbers read from stdin line by line until the end of input (Ctrl-D or [end of file](https://en.wikipedia.org/wiki/End-of-file)).

The loop will also end if the input is not a valid number.

`Task.loop` starts from an initial state and sends it to a provided function that will return a new Task.
- If this new Task matches `Task.ok (Step newState)` then the loop continues with a new call of the same function, now using `newState`.
- If it's of the form `Task.ok (Done finalState)` then the loop stops and returns `finalState`.
- If the Task is a `Task.err err`, then the loop stops and returns the error.

## Code

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
