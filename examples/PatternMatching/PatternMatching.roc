module []

# Match an empty list
expect
    match = |input|
        when input is
            [] -> EmptyList
            _ -> Other

    match([])
    == EmptyList
    and match([A, B, C])
    != EmptyList

# Match a non-empty list
expect
    match = |input|
        when input is
            [_, ..] -> NonEmptyList
            _ -> Other

    match([A, B, C])
    == NonEmptyList
    and match([])
    != NonEmptyList

# Match a list whose first element is the string "Hi"
expect
    match = |input|
        when input is
            ["Hi", ..] -> StartsWithHi
            _ -> Other

    match(["Hi", "Hello", "Yo"])
    == StartsWithHi
    and match(["Hello", "Yo", "Hi"])
    != StartsWithHi

# Match a list whose last element is the number 42
expect
    match = |input|
        when input is
            [.., 42] -> EndsWith42
            _ -> Other

    match([24, 64, 42])
    == EndsWith42
    and match([42, 1, 5])
    != EndsWith42

# Match a list that starts with a Foo tag
# followed by a Bar tag
expect
    match = |input|
        when input is
            [Foo, Bar, ..] -> StartsWithFooBar
            _ -> Other

    match([Foo, Bar, Bar])
    == StartsWithFooBar
    and match([Bar, Bar, Foo])
    != StartsWithFooBar

# Match a list with these exact elements:
# Foo, Bar, and then (Baz "Hi")
expect
    match = |input|
        when input is
            [Foo, Bar, Baz("Hi")] -> FooBarBazStr
            _ -> Other

    match([Foo, Bar, Baz("Hi")])
    == FooBarBazStr
    and match([Foo, Bar])
    != FooBarBazStr
    and match([Foo, Bar, Baz("Hi"), Blah])
    != FooBarBazStr

# Match a list with Foo as its first element, and
# Count for its second element. Count holds a number,
# and we only match if that number is greater than 0.
expect
    match = |input|
        when input is
            [Foo, Count(num), ..] if num > 0 -> FooCountIf
            _ -> Other

    match([Foo, Count(1)])
    == FooCountIf
    and match([Foo, Count(0)])
    != FooCountIf
    and match([Baz, Count(1)])
    != FooCountIf

# Use `as` to create a variable equal to the part of the list that matches `..`
expect
    match = |input|
        when input is
            [head, .. as tail] -> HeadAndTail(head, tail)
            _ -> Other

    match([1, 2, 3])
    == HeadAndTail(1, [2, 3])
    and match([1, 2])
    == HeadAndTail(1, [2])
    and match([1])
    == HeadAndTail(1, [])
    and match([])
    == Other
