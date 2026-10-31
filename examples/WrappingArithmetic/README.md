# Wrapping and Saturating Arithmetic

This example compares wrapping and saturating arithmetic when a result goes beyond an integer type’s bounds. It uses small integer types so we can easily see what happens when addition, subtraction, or multiplication overflows.

```roc
file:main.roc:snippet:example
```

Wrapping continues at the opposite bound: adding ten to `250.U8` wraps around to `4`. Saturating arithmetic stops at the nearest bound instead, giving `255` for the same addition.

Ordinary `+`, `-`, and `*` crash on overflow. If you would prefer to handle overflow as an error, the [Safe Math example](../SafeMath/README.md) shows the fallible arithmetic methods.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (6) tests passed in 10.8 ms.
```
