# Recursive and Mutually Recursive Types

This example builds and evaluates a tiny expression tree containing numbers, additions, and blocks of statements. The two top-level types, `Expr` and `Stmt`, demonstrate both recursion and mutual recursion without needing an enclosing type.

```roc
file:main.roc:snippet:example
```

`Expr` refers to itself through the two operands of `Add`. It also refers to `Stmt` through `Block`, while `Stmt` refers back to `Expr` through `Yield`. Together, those references let us nest expressions inside statements and statements inside expressions.

Every type in a recursive cycle must be nominal (`:=` or `::`). A type alias (`:`) cannot be used to define such a cycle.

For an example of grouping related types within a type module, see [Nested Types](../NestedTypes/README.md).

Run `roc test main.roc` from this directory.
