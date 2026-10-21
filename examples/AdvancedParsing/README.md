# Advanced Parsing

This example parses a user profile from camelCase JSON, including fields that may be missing and a field with a default value. It also parses HTTP headers to show how Roc’s type-directed parsing works with formats other than JSON.

```roc
file:main.roc:snippet:example
```

The user profile demonstrates three ways to handle a missing field:

- `nickname ?: Str` declares an optional field. Reading it with `.?nickname` returns a `Try`, and `??` lets us supply a default when it is absent.
- `email : Try(Str, [Missing])` represents absence explicitly as `Err(Missing)`.
- `role : [Restricted, Admin] ?? Restricted` gives the field a default value. When `role` is missing from the JSON, the parser fills in `Restricted`; an explicit `"role": "Admin"` overrides that default. The resulting record always has this field, so we can read it directly with `.role`.

Fields such as `user_name` remain required. Unlike the fallback in `user.?nickname ?? "anonymous"`, which only supplies a value when reading the optional field, the `role` default becomes part of the parsed record.

Field defaults belong to nominal records, so `User` uses `:=` rather than the type-alias syntax `:`. Nominal types also need to opt into derived parsing: `parser_for : _` asks Roc to generate the parser for this record.

`parser_camel()` connects the JSON field `userName` to Roc’s `user_name`. Because we define the parser at the top level, it is assembled at compile time and is ready to parse input at runtime.

The HTTP header example uses the same approach: we describe the record we want, and the format’s parser fills it in.

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc test main.roc

All (6) tests passed in 101.4 ms.
```
