# Local Dispatch with Arrow Operator

This example demonstrates the `->` arrow operator for local dispatch, which replaces the pizza operator `|>` from old Roc.

## Overview

In new Roc, there are two ways to chain function calls:

1. **Method syntax** (`.method()`) - for methods defined on a type
2. **Local dispatch** (`->function`) - for functions in local scope

## The Arrow Operator

The `->` operator passes the left-hand value as the first argument to the function on the right:

```roc
# These are equivalent:
double(5)
5->double

# Chain multiple calls (reads left-to-right):
3->double->add_ten->square
# Same as: square(add_ten(double(3)))
```

## Defining Helper Functions

```roc
double : I64 -> I64
double = |n| n * 2

add_ten : I64 -> I64
add_ten = |n| n + 10

square : I64 -> I64
square = |n| n * n
```

## Mixing Method Syntax and Local Dispatch

You can combine both styles in a single expression:

```roc
wrap_parens : Str -> Str
wrap_parens = |s| "(${s})"

format_number : I64 -> Str
format_number = |n|
    n.to_str()->wrap_parens  # method, then local dispatch
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
5->double = 10
3->double->add_ten->square = 256
chain_math(2) = 196
42->format_number = (42)

Style comparison:
  square(add_ten(double(7))) = 576
  7->double->add_ten->square = 576
```

## When to Use Each Style

| Style | Syntax | Use When |
|-------|--------|----------|
| Method syntax | `value.method()` | Calling methods defined on the type |
| Local dispatch | `value->function` | Calling local functions for left-to-right chaining |
| Traditional | `function(value)` | Simple single calls or when nesting is clear |
