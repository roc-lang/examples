# Error handling Real World

A more complex "real world" example that demonstrates the use of `Result`, `?` and error handling in Roc.

See also:
- [Basic error handling](https://www.roc-lang.org/examples/ErrorHandlingBasic/README) for a simpler example.
- [Desugaring `?`](https://www.roc-lang.org/examples/TryOperatorDesugaring/README) to understand how `?` is converted under the hood.

## Full Code

```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```sh
$ HELLO=1 roc main.roc -- "https://www.roc-lang.org" roc.html
HELLO env var was set to 1.
Fetching content from https://www.roc-lang.org...
Saving HTML to roc.html...
Contents of current directory: ./roc.html,./main.roc,./README.md
Run time: 217 ms
Done
```

