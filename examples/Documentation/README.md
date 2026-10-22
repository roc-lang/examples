# Generating Documentation

This example documents a small `Counter` type and uses `roc docs` to turn its comments into a browsable API reference. It shows how to describe public methods and link between them, with a separate test checking the counter’s behavior.

Here is the test that uses the documented type:

```roc
file:main.roc:snippet:example
```

In `Counter.roc`, the `##` comments become API documentation. They can contain Markdown, including links such as `[zero]` and `[increment]` to other documented methods. Ordinary `#` comments remain implementation notes:

```roc
file:Counter.roc
```

The package entry point exposes `Counter`, making it available to the documentation generator:

```roc
file:package.roc
```

## Output

From this directory, generate the documentation site with:

```sh
roc docs package.roc --output=generated-docs
```

The generated site starts at `generated-docs/index.html`.

If you would like to preview it in a browser, `roc docs package.roc --serve` generates the documentation and starts a local server.

You can also check the example’s behavior:

```text
$ roc test main.roc

All (1) tests passed in 8.4 ms.
```
