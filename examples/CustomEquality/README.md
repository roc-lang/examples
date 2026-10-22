# Custom Equality and Hashing

This example shows how to create a custom type whose values can be inserted in a `Set` (or used as keys in a `Dict`). For this to work, Roc requires the type to provide at least two methods: `is_eq` and `to_hash`.

```roc
file:main.roc:snippet:example
```

Our `User` type treats the ID as the user’s identity: two values with the same `id` are equal, even if their display names differ. That is why inserting both `original` and `renamed` into the set only adds one user.

The two methods need to agree: whenever `is_eq` considers two values equal, `to_hash` must hash them the same way. Here, both methods use only `id`. Hashing the whole record would include the name, so it would no longer agree with our equality rule.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (4) tests passed in 31.0 ms.
```
