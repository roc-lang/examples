# Encoding with Static Dispatch (Advanced)

An advanced example demonstrating encoding with static dispatch, including custom type encoding.

For a simpler introduction, see [EncodeDecode](../EncodeDecode/).

<!-- TODO: Update to notebook file format once implemented in the new compiler -->

## Overview

The Encode module uses static dispatch via where clauses:
- `Str.encode` requires: `where [fmt.encode_str : fmt, Str -> Try(encoded, err)]`
- `List.encode` requires: `where [fmt.encode_list : fmt, List(item), (item, fmt -> Try(encoded, err)) -> Try(encoded, err)]`

This example shows how to create a custom JSON-like format type that implements these methods.

## Custom Format Type

```roc
JsonFormat := [Format].{
    encode_str : JsonFormat, Str -> Try(List(U8), [])
    encode_str = |_fmt, str| {
        quoted = "\"${str}\""
        Ok(Str.to_utf8(quoted))
    }

    encode_list : JsonFormat, List(item), (item, JsonFormat -> Try(List(U8), err)) -> Try(List(U8), err)
    encode_list = |fmt, items, encode_item| {
        # Build JSON array: [item1,item2,...]
        ...
    }
}
```

## Custom Type Encoding

```roc
Person := [Person({ name : Str, age : U64 })].{
    # TODO: Use auto derive for encode when it is implemented
    encode : Person, JsonFormat -> Try(List(U8), [])
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
