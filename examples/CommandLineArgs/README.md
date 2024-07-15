# CLI Args

Shows how to read command line arguments.
To pass an argument: `roc main.roc some_argument` or `roc -- some_argument` or `roc build && ./main some_argument`.

We also have [a more complex example that uses a filename as argument](https://www.roc-lang.org/examples/CommandLineArgsFile/README.html).

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc some_argument
received argument: some_argument
```
