# Using ? in Tests

These tests show how `?` can simplify a top-level `expect` when the code being tested returns a `Try`. We parse numbers and JSON, then check the successful values without having to write a `match` for each result.

```roc
file:main.roc:snippet:example
```

Inside an `expect`, `?` unwraps `Ok` and fails the test if it encounters `Err`. When an error is the expected outcome, we check it directly instead, as the final test does with `.is_err()`.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (3) tests passed in 14.6 ms.
```
