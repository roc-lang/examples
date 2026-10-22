# Filesystem Paths

This example uses the [path package](https://github.com/roc-lang/path) to join a directory and filename, then extract the filename and extension. It also creates a raw Unix path to show why filesystem paths cannot always be represented as Unicode strings.

```roc
file:main.roc:snippet:example
```

The raw path contains a byte that is not valid UTF-8, so `to_str` returns an error. `to_raw` preserves the original representation, which is what a platform needs when passing the path to the operating system. The package also supports Windows paths stored as UTF-16 code units.

For human-readable output, `display` can replace invalid text. That makes it useful for showing a path, but unsuitable for reconstructing the original path later.

These operations only manipulate path values; they do not access the filesystem. The app header selects the package release used by the example:

```roc
file:main.roc:snippet:header
```

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (5) tests passed in 31.7 ms.
```
