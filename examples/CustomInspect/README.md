# Custom Inspect

An [Opaque type](https://www.roc-lang.org/tutorial#opaque-types) can control the output of `Str.inspect` being called on itself by implementing `to_inspect`.

This can be useful for more complex types, or to hide internal implementation details.

## Simple Tag Union
```roc
file:OpaqueTypes.roc:snippet:color
```

## Redacting a Secret
```roc
file:OpaqueTypes.roc:snippet:secret
```

## Output

Run the tests from the directory that has `OpaqueTypes.roc` in it:

```text
$ roc test OpaqueTypes.roc
All (4) tests passed.
```

The tests check the custom color names and the redacted credit card number.
