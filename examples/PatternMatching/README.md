# Pattern Matching on Lists

All the ways to pattern match on lists:
```roc
match input {
    [] => EmptyList,

    [_, ..] => NonEmptyList,

    ["Hi", ..] => StartsWithHi,

    [.., 42] => EndsWith42,

    [Foo, Bar, ..] => StartsWithFooBar,

    [Foo, Bar, Baz("Hi")] => FooBarBazStr,

    [Foo, Count(num), ..] if num > 0 => FooCountIf,

    [head, .. as tail] => HeadAndTail(head, tail),

    _ => Other,
}
```
Note: this specific snippet would not typecheck because it uses lists of different types.
This is just meant to be a compact overview. See the code section below for valid Roc.

## Code
```roc
file:PatternMatching.roc
```

## Output

Run this from the directory that has `PatternMatching.roc` in it:

```
$ roc test PatternMatching.roc

All (8) tests passed in 11.1 ms.
```
