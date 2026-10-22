# Nominal and Opaque Types

This example uses nominal types (`:=`) to keep meters and seconds distinct, even though both contain a number. It then uses an opaque nominal type (`::`) to ensure that a `Positive` value can only be created through a constructor that rejects zero.

```roc
file:main.roc:snippet:example
```

The `Positive` type lives in a separate module, where its backing number is hidden from callers. Its constructor is the only way for this app to create a value, so the check against zero cannot be bypassed:

```roc
file:Positive.roc
```

If we only wanted a shorter name for an existing type, we could use a type alias (`:`). Unlike the nominal types above, an alias does not give the type a separate identity.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (3) tests passed in 10.2 ms.
```
