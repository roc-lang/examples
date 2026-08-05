# Encoding & Decoding Abilities

An example for how to implement the builtin `encoder_for` and `parser_for` functions for a nominal type (`ItemKind`).

Implementing these functions for a nominal type like `ItemKind`, enables it to be used seamlessly within other data structures.
This is useful when you would like to provide a custom mapping, such as in this example, between an integer and a [tag union](https://www.roc-lang.org/tutorial#tag-union-types).

> If you prefer to use the default `encoder_for` and `parser_for` functions, simply add `encoder_for : _` and `parser_for : _` to your type.

## Implementation
```roc
file:main.roc:snippet:impl
```

## Demo
```roc
file:main.roc:snippet:demo
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
ItemKind.(Text)
ItemKind.(Method)
ItemKind.(Function)
ItemKind.(Constructor)
ItemKind.(Field)
ItemKind.(Variable)
ItemKind.(Class)
ItemKind.(Interface)
ItemKind.(Module)
ItemKind.(Property)
```

You can also use `roc test` to run the tests.
