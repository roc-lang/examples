# Loops and Local Variables

This example calculates the same sum three ways, using `for`, `while`, and `fold`. The loop versions use local variables, showing that reassignment inside a function can still be part of a pure computation.

```roc
file:main.roc:snippet:example
```

The `for` version follows the items in the list, while the `while` version keeps going as long as there are items left. The `fold` version expresses the same calculation by passing the running total from one step to the next.

A `var` can only be reassigned inside the function that declares it. That local reassignment does not make the function effectful, so all three versions have the same pure function type.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (4) tests passed in 11.4 ms.
```
