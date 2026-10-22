# Authoring a Package

This example creates a small package that exposes a `Greeting` module, then imports it into an app. It shows how the package entry point, public module, and app dependency fit together before the package is bundled for distribution.

The app calls the package’s greeting function and checks its result:

```roc
file:main.roc:snippet:example
```

The package entry point lists the modules available to consumers. Here, we expose just `Greeting`:

```roc
file:package/main.roc
```

`Greeting.roc` contains the public function that consumers can call:

```roc
file:package/Greeting.roc
```

While developing the package, we can refer to its local entry point in the app header. That lets us edit the package and test the app together:

```roc
file:main.roc:snippet:header
```

When the package is ready to share, `roc bundle package/main.roc` produces a `.tar.zst` archive whose name identifies its contents. After uploading that archive to a release, consumers can use its full HTTPS URL in place of the local path.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (1) tests passed in 8.5 ms.
```
