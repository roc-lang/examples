# Sorting Strings

Here we show how to sort a list of `Str` in ascending and descending order.

## ASCII

If you're sure all your input `Str` will consist of ascii characters (see "Printable character table" [here](https://en.wikipedia.org/wiki/ASCII)) you can
use the [ascii package](https://github.com/Hasnep/roc-ascii). This example uses [ageron's fork](https://github.com/ageron/roc-ascii), which is up to date with the latest Roc nightlies.

### Code

```roc
file:main.roc
```

## Unicode

`Str` has no built-in ordering, so we compare strings ourselves. Comparing UTF-8 bytes sorts by code point, which puts every uppercase letter before every lowercase one. To ignore case, we sort by each string's case folded form using the [unicode package](https://github.com/roc-lang/unicode). Full case folding also handles non-ASCII text, `ß` folds to `ss` for example.

The code for this is part of the same file as the ASCII example above.
