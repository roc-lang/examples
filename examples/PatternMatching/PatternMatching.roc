interface PatternMatching
    exposes []
    imports []

# Pattern match on an empty list
expect
    patternMatch = \input ->
        when input is
            [] -> EmptyList
            _ -> Other

    (patternMatch [] == EmptyList)
    && (patternMatch [A, B, C] != EmptyList)

# Pattern match on a non-empty list
expect
    patternMatch = \input ->
        when input is
            [_, ..] -> NonEmptyList
            _ -> Other

    (patternMatch [A, B, C] == NonEmptyList)
    && (patternMatch [] != NonEmptyList)

# Pattern match on a list that starts with exactly Foo tag
expect
    patternMatch = \input ->
        when input is
            [Foo, ..] -> StartsWithFoo
            _ -> Other

    (patternMatch [Foo, Bar, Baz] == StartsWithFoo)
    && (patternMatch [Baz, Bar, Foo] != StartsWithFoo)

# Pattern match on a list that ends with a Foo tag
expect
    patternMatch = \input ->
        when input is
            [.., Foo] -> EndWithFoo
            _ -> Other

    (patternMatch [Baz, Bar, Foo] == EndWithFoo)
    && (patternMatch [Foo, Bar, Baz] != EndWithFoo)

# Pattern match on a list that starts with a Foo tag followed by a Bar tag
expect
    patternMatch = \input ->
        when input is
            [Foo, Bar, ..] -> FooBar
            _ -> Other

    (patternMatch [Foo, Bar, Bar] == FooBar)
    && (patternMatch [Bar, Bar, Foo] != FooBar)

# Pattern match on a list with these exact elements: Foo, Bar, and then Baz
expect
    patternMatch = \input ->
        when input is
            [Foo, Bar, Baz] -> Bingo
            _ -> Other

    (patternMatch [Foo, Bar, Baz] == Bingo)
    && (patternMatch [Foo, Bar] != Bingo)
    # TODO: reenable line below when roc-lang/examples/issues/25 is fixed
    # && (patternMatch [Foo, Bar, Baz, Barry] != Bingo)

# Pattern match on a list with first element Foo, and then a second we name `a`
expect
    patternMatch = \input ->
        when input is
            [Foo, a, ..] ->
                if a == Bar then
                    FooBar
                else
                    Other

            _ -> Other

    patternMatch [Foo, Bar] == FooBar
