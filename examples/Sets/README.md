# Sets

This example uses sets to represent the members of two teams. It shows how duplicate names are removed, how to check membership, and how to find everyone on either team, on both teams, or only on the backend team.

```roc
file:main.roc:snippet:example
```

The final example collects an iterator into a `Set(U64)`, removing duplicate numbers along the way.

Set elements need to support equality and hashing, which strings and integers already do. For your own types, see [Custom Equality and Hashing](../CustomEquality/README.md).

A set’s iteration order is not guaranteed, so the tests compare membership rather than expecting a particular order.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (6) tests passed in 32.6 ms.
```
