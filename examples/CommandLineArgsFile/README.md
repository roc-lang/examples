# CLI Args

Use command line arguments to read a file.
To pass an argument: `roc main.roc input.txt` or `roc -- input.txt` or `roc build && ./main input.txt`.

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc -- input.txt
file content: 42
```
