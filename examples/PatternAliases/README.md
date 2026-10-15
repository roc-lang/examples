# Whole-Pattern Aliases

This example uses `as` to inspect a result while keeping the whole value available. The `positive` function checks the number inside `Ok`, returns the original result if it is positive, and passes existing errors through unchanged.

```roc
file:main.roc:snippet:example
```

In `Ok(n) as result`, `n` is the number and `result` is the complete `Ok(n)` value. This lets us examine part of a value without having to reconstruct the whole thing when returning it.

Run `roc test main.roc` from this directory.
