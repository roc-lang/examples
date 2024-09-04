# Custom Inspect

An [Opaque type](https://www.roc-lang.org/tutorial#opaque-types) can provide a custom implementation for the [Inspect](https://www.roc-lang.org/builtins/Inspect) ability.

This can be useful for more complex types, or to hide internal implementation details.

## Simple Tag Union
```roc
file:OpaqueTypes.roc:snippet:color
```

## Redacting a Secret
```roc
file:OpaqueTypes.roc:snippet:secret
```
