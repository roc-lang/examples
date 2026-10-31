# Nested Types

This example defines an `Order` and gives it a nested `Status` type for tracking whether it has shipped. Keeping the two types in the same module lets callers import `Order` once and refer to its status as `Order.Status`.

Here is the type module in `Order.roc`:

```roc
file:Order.roc
```

`Order` is a record that holds an item and its status. Inside its associated block, `Status` defines the states that an order can have, alongside methods for creating and shipping an order.

The app can use both types through the same import:

```roc
file:main.roc:snippet:example
```

This grouping gives the status a clear owner: it is an order status, rather than a general-purpose `Status` type. Since a type module exposes one top-level type, nesting also lets that type’s public API include related types without putting each in a separate module.

Nesting is independent of recursion. The [Recursive Types example](../RecursiveTypes/README.md) shows types that refer to themselves and each other without an enclosing type.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (3) tests passed in 9.5 ms.
```
