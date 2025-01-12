# Error handling with try and Result

A more complex "real world" example that demonstrates the use of `Result`, `?` and error handling in Roc. 

## Full Code

```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```sh
$ HELLO=1 roc examples/ErrorHandling/main.roc -- "https://www.roc-lang.org" roc.html
HELLO env var was set to 1
Fetching content from https://www.roc-lang.org...
Saving url HTML to roc.html...
Contents of current directory: [...]
Run time: 329 ms
Done
```

