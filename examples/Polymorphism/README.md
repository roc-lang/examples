# Polymorphism and Where Clauses

This example starts with `duplicate`, a function that works with any type, then adds functions that need a `to_str` method. It shows how a `where` clause expresses that requirement and how a reusable `where` alias avoids repeating it.

```roc
file:main.roc:snippet:example
```

`duplicate` does not need to know anything about its argument’s type: it simply returns the value twice. By contrast, `show` calls `to_str`, so its annotation requires the argument’s type to provide that method.

`a.Showable` gives that requirement a name that `show_pair` can reuse. A type satisfies the alias by providing the required methods; there is no separate implementation declaration to write.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (4) tests passed in 7.2 ms.
```
