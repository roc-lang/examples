# Ingest Files

To statically import files as a `Str` or a `List U8` (list of bytes):

```roc
import "some-file.txt" as some_str : Str
import "some-file" as some_bytes : List U8
```

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
The quick brown fox jumps over the lazy dog
```
