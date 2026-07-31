# Basic Dict Usage

[Docs for Dict](https://www.roc-lang.org/docs/main/Dict/)

## What's a Dict?

A `Dict` (dictionary) lets you save a value under a key, so that you end up with a collection of key-value pairs.
For example, you can create a Dict to keep track of how much fruit you have:

```roc
fruit_dict : Dict(Str, U64)
fruit_dict =
    Dict.empty()
        .insert("Apple", 3)
        .insert("Banana", 2)
``` 

## Basic Dict Examples

```roc
file:BasicDict.roc
```

## Constraints

The type of the key must implement `is_eq` and `to_hash`, while the type of the
value must implement `is_eq`.

Nearly all Roc builtin types (`Str`, `Bool`, `List`, `U64`...) implement these.

If you are defining an opaque type, adding `is_eq : _` and `to_hash : _` is all you need to be able to use it as a key:
```roc
Username := Str.{
    is_eq : _
    to_hash : _
}
```

## Output

Run this from the directory that has `BasicDict.roc` in it:

```
$ roc test BasicDict.roc

All (7) tests passed in 50 ms.
```
