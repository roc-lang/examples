# Mutually Recursive Functions

This example defines `is_even` and `is_odd` in terms of each other: a positive number is even if the previous number is odd, and vice versa. It demonstrates mutual recursion and why the position of a recursive call matters for stack usage.

```roc
file:main.roc:snippet:example
```

Roc allows the two functions to refer to each other without forward declarations. Each recursive call is also in tail position: its result becomes the calling function’s result immediately.

Roc guarantees that these tail calls do not grow the stack. If we did more work after a call, such as adding to its result, it would no longer be a tail call. The [tail-call optimization documentation](https://www.roc-lang.org/docs/main/langref/functions/#tail-call-optimization) explains this distinction in more detail.

Run `roc test main.roc` from this directory.
