# JSON

Decode JSON data into a Roc record.

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

> Note: `--linker=legacy` is used here because of https://github.com/roc-lang/roc/issues/3609

```
$ roc main.roc --linker=legacy
Successfully decoded image, title:"View from 15th Floor"
```
