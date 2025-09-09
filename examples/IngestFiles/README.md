# Ingest Files

To import files as a `Str` or a `List U8` (list of bytes):

```roc
import "some-file.txt" as some_str : Str
import "some-file" as some_bytes : List U8
```

This prevents needing to set up the error handling for the file reading.

The file content is included in the Roc app executable, if you publish the executable, you do not need to provide the file alongside it. 

## Full Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
Contents of sample.txt: The quick brown fox jumps over the lazy dog
```
