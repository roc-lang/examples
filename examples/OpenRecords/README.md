# Open Record Types

This example shows how to write functions that accept any record with a `name` field. `greet` only reads that field, while `rename` changes it and preserves whatever other fields the caller supplied.

```roc
file:main.roc:snippet:example
```

The `..others` part of the annotation makes the record open to additional fields. Using the same `..others` in `rename`’s input and output preserves those fields and their types, so the caller’s `age` survives the rename.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (3) tests passed in 6.2 ms.
```
