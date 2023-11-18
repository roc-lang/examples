# Ingest Files

Statically importing files as a `Str` or a `List U8`.

```roc
imports [
    "some-file" as someStr : Str,
    "some-file" as someBytes : List U8,
]
```

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc run main.roc
The quick brown fox jumps over the lazy dog
```
