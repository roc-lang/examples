interface PatternMatching
    exposes []
    imports []

# Match an empty list
expect
    match = \input ->
        when input is
            [] -> EmptyList
            _ -> Other

    (match [] == EmptyList)
    && (match [A, B, C] != EmptyList)

# Match a non-empty list
expect
    match = \input ->
        when input is
            [_, ..] -> NonEmptyList
            _ -> Other

    (match [A, B, C] == NonEmptyList)
    && (match [] != NonEmptyList)

# Match a list whose first element is the string "Hi"
expect
    match = \input ->
        when input is
            ["Hi", ..] -> StartsWithHi
            _ -> Other

    (match ["Hi", "Hello", "Yo"] == StartsWithHi)
    && (match ["Hello", "Yo", "Hi"] != StartsWithHi)

# Match a list whose last element is the number 42
expect
    match = \input ->
        when input is
            [.., 42] -> EndWith42
            _ -> Other

    (match [24, 64, 42] == EndWith42)
    && (match [42, 1, 5] != EndWith42)

# Match a list that starts with a Foo tag
# followed by a Bar tag
expect
    match = \input ->
        when input is
            [Foo, Bar, ..] -> FooBar
            _ -> Other

    (match [Foo, Bar, Bar] == FooBar)
    && (match [Bar, Bar, Foo] != FooBar)

# Match a list with these exact elements:
# Foo, Bar, and then (Baz "Hi")
expect
    match = \input ->
        when input is
            [Foo, Bar, Baz "Hi"] -> Bingo
            _ -> Other

    (match [Foo, Bar, Baz "Hi"] == Bingo)
    && (match [Foo, Bar] != Bingo)
    && (match [Foo, Bar, Baz "Hi", Blah] != Bingo)

# Match a list with Foo as its first element, and
# Count for its second element. Count holds a number,
# and we only match if that number is greater than 0.
expect
    match = \input ->
        when input is
            [Foo, Count num, ..] if num > 0 -> FooBar
            _ -> Other

    (match [Foo, Count 1] == FooBar)
    && (match [Foo, Count 0] != FooBar)
    && (match [Baz, Count 1] != FooBar)
