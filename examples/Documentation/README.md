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

From this directory, you can generate the site with:

```sh
roc docs package.roc --output=generated-docs
```

If you would like to preview it in a browser, `roc docs package.roc --serve` generates the documentation and starts a local server.

You can also run `roc test main.roc` to check the example’s behavior.
