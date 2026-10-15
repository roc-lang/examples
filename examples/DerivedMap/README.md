# Derived map and map!

This example models data that is still loading, has loaded successfully, or failed to load. It asks Roc to generate `map` and `map!` for a custom `LoadState` type, so we can transform a loaded user profile into a name while preserving the loading and failure states.

```roc
file:main.roc:snippet:example
```

The declarations `map : _` and `map! : _` ask the compiler to derive the implementations from the tag union’s shape. They transform the payload of `Loaded(a)`, where the type parameter appears. The result can have a different payload type: here, a user record becomes a `Str`.

With `map`, the transformation is pure. With `map!`, it can also perform effects, as the printing function in `main!` does. For `Loading` or `Failed`, neither method calls the transformation; the state passes through unchanged.

With this compiler version, derived mapping requires a single data-carrying payload. That is why `Failed` has no error message here; adding a `Str` payload to it would require implementing the mapping methods ourselves.

Run `roc main.roc` and `roc test main.roc` from this directory.
