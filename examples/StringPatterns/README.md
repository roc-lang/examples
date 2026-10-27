# String Capture Patterns

This example first extracts a filename from a path such as `notes/todo.txt`, then captures and parses a numeric user ID from a path such as `users/42`. String capture patterns let us match the fixed parts of each string and give the variable part a name.

```roc
file:main.roc:snippet:example
```

Captured values are strings: `filename` returns the captured name directly, while `route` uses `U64.from_str` to convert the captured ID into a number. A matching path with an invalid ID returns `InvalidId`; a path that does not match `users/${id}` returns `NotFound`.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (5) tests passed in 9.8 ms.
```
