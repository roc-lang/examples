# Encoding with Static Dispatch (Minimal)

A minimal example demonstrating encoding with static dispatch.

For a more advanced example with custom types, see [EncodeDecodeAdvanced](../EncodeDecodeAdvanced/).

<!-- TODO: Update to notebook file format once implemented in the new compiler -->

## Overview

The Encode module uses static dispatch via where clauses. To encode values, you define a format type with the required methods:

```roc
JsonFormat := [Format].{
    encode_str : JsonFormat, Str -> Try(List(U8), [])
    encode_str = |_fmt, str| {
        quoted = "\"${str}\""
        Ok(Str.to_utf8(quoted))
    }

    encode_list : JsonFormat, List(item), (item, JsonFormat -> Try(List(U8), err)) -> Try(List(U8), err)
    encode_list = |fmt, items, encode_item| {
        # Build JSON array...
    }
}
```

Then use it:

```roc
json_fmt = JsonFormat.Format
encoded = "Hello".encode(json_fmt)?  # => Ok(['"', 'H', 'e', 'l', 'l', 'o', '"'])
```

## Output

```
$ roc main.roc
Encoded string:
  Input: Hello, World!
  As JSON: "Hello, World!"

Encoded list:
  Input: ["Alice", "Bob", "Charlie"]
  As JSON: ["Alice","Bob","Charlie"]
```
