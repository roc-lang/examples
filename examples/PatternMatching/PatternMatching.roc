# Match an empty list
expect {
	match_fn = |input|
		match input {
			[] => EmptyList
			_ => Other
		}

	match_fn([]) == EmptyList and match_fn([A, B, C]) == Other
}

# Match a non-empty list
expect {
	match_fn = |input|
		match input {
			[_, ..] => NonEmptyList
			_ => Other
		}

	match_fn([A, B, C]) == NonEmptyList and match_fn([]) == Other
}

# Match a list whose first element is the string "Hi"
expect {
	match_fn = |input|
		match input {
			["Hi", ..] => StartsWithHi
			_ => Other
		}

	match_fn(["Hi", "Hello", "Yo"]) == StartsWithHi and match_fn(["Hello", "Yo", "Hi"]) == Other
}

# Match a list whose last element is the number 42
expect {
	match_fn = |input|
		match input {
			[.., 42] => EndsWith42
			_ => Other
		}

	match_fn([24, 64, 42]) == EndsWith42 and match_fn([42, 1, 5]) == Other
}

# Match a list that starts with a Foo tag
# followed by a Bar tag
expect {
	match_fn = |input|
		match input {
			[Foo, Bar, ..] => StartsWithFooBar
			_ => Other
		}

	match_fn([Foo, Bar, Bar]) == StartsWithFooBar and match_fn([Bar, Bar, Foo]) == Other
}

# Match a list with these exact elements:
# Foo, Bar, and then (Baz "Hi")
expect {
	match_fn = |input|
		match input {
			[Foo, Bar, Baz("Hi")] => FooBarBazStr
			_ => Other
		}

	match_fn([Foo, Bar, Baz("Hi")])
		== FooBarBazStr
		and
		match_fn([Foo, Bar])
			== Other
			and
			match_fn([Foo, Bar, Baz("Hi"), Blah])
				== Other
}

# Match a list with Foo as its first element, and
# Count for its second element. Count holds a number,
# and we only match if that number is greater than 0.
expect {
	match_fn = |input|
		match input {
			[Foo, Count(num), ..] if num > 0 => FooCountIf
			_ => Other
		}

	match_fn([Foo, Count(1)])
		== FooCountIf
		and match_fn([Foo, Count(0)])
			== Other
			and match_fn([Baz, Count(1)])
				== Other
}

# Use `as` to create a variable equal to the part of the list that matches `..`
expect {
	match_fn = |input|
		match input {
			[head, .. as tail] => HeadAndTail(head, tail)
			_ => Other
		}

	match_fn([1, 2, 3])
		== HeadAndTail(1, [2, 3])
		and match_fn([1, 2])
			== HeadAndTail(1, [2])
			and match_fn([1])
				== HeadAndTail(1, [])
				and match_fn([])
					== Other
}

main! = |_| Ok({})
