# Basic Rust GUI

This is a basic GUI platform using Rust.

1. Build the platform using `roc build.roc`
2. Run an example using `roc hello-gui.roc` or `roc inspect.gui.roc`

## Hello-GUI Example

```roc
file:hello-gui.roc
```

## Inspect-GUI Example

```roc
file:inspect-gui.roc
```

## Developing

You can re-generate the `roc_std` crate using `bash glue-gen.sh`. This will use the `RustGlue.roc` script in the roc repository to vendor the roc std library types for use in this platform.
