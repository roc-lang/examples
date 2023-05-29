
# Ingest Files

This is an example of how to import files directly as a `Str` or a `List U8`.

```roc
imports [
    "some-file" as someStr : Str,
    "some-file" as someBytes : List U8,
]
```

## Output

```
% roc run main.roc           
The quick brown fox jumps over the lazy dog
```

## Code
```roc
file:main.roc
```