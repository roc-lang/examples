# Encoding with Static Dispatch

An example demonstrating the new Encode module with static dispatch using where clauses.

Based on: https://github.com/roc-lang/roc/commit/22cf61ff9332f0de7a0d5d7f42b7f5836232a744

## Overview

The Encode module uses static dispatch via where clauses:
- `Str.encode` requires: `where [fmt.encode_str : fmt, Str -> List(U8)]`
- `List.encode` requires: `where [fmt.encode_list : fmt, List(item), (item, fmt -> List(U8)) -> List(U8)]`

This example shows how to create a custom JSON-like format type that implements these methods.

## Custom Format Type

```roc
JsonFormat := [Format].{
    encode_str : JsonFormat, Str -> List(U8)
    encode_str = |_fmt, str| {
        quoted = "\"${str}\""
        Str.to_utf8(quoted)
    }

    encode_list : JsonFormat, List(item), (item, JsonFormat -> List(U8)) -> List(U8)
    encode_list = |fmt, items, encode_item| {
        # Build JSON array: [item1,item2,...]
        ...
    }
}
```

## Custom Type Encoding

```roc
Person := [Person({ name : Str, age : U64 })].{
    encode : Person, JsonFormat -> List(U8)
    encode = |self, fmt| {
        match self {
            Person({ name, age }) => {
                # Builds: {"name":"...","age":...}
                ...
            }
        }
    }
}
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
Encoded string:
  Input: Hello, World!
  As JSON: "Hello, World!"

Encoded list of strings:
  Input: ["Alice", "Bob", "Charlie"]
  As JSON: ["Alice","Bob","Charlie"]

Encoded Person object:
  Input: { name: "Alice", age: 30 }
  As JSON: {"name":"Alice","age":30}

Encoded list of Person objects:
  Input: [{ name: "Alice", age: 30 }, { name: "Bob", age: 25 }, { name: "Charlie", age: 35 }]
  As JSON: [{"name":"Alice","age":30},{"name":"Bob","age":25},{"name":"Charlie","age":35}]
```
