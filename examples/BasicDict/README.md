# Basic Dict Usage

[Docs for Dict](https://www.roc-lang.org/builtins/Dict)

[Full implementation of Dict](https://github.com/roc-lang/roc/blob/main/crates/compiler/builtins/roc/Dict.roc)

## What's a Dict?

A `Dict` (dictionary) lets you save a value under a key, so that you end up with a collection of key-value pairs.
For example, you can create a Dict to keep track of how much fruit you have:

```roc
fruit_dict : Dict Str U64
fruit_dict =
    Dict.empty({})
    |> Dict.insert("Apple", 3)
    |> Dict.insert("Banana", 2)
``` 

## Basic Dict Examples

```roc
file:BasicDict.roc
```

## Constraints

The type of the key must implement the `Hash` and `Eq` abilities.
Nearly all Roc builtin types (`Str`, `Bool`, `List`, `Int *`,...) implement these.

If you are defining an [opaque type](https://www.roc-lang.org/tutorial#opaque-types), adding `implements [Hash, Eq]` is all you need to be able to use it as a key:
```roc
Username := Str implements [Hash, Eq]
```

## Output

Run this from the directory that has `BasicDict.roc` in it:

```
$ roc test BasicDict.roc

0 failed and 8 passed in 144 ms.
```
