app [] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
is_even : U64 -> Bool
is_even = |n| if n == 0 {
	True
} else {
	is_odd(n - 1)
}

is_odd : U64 -> Bool
is_odd = |n| if n == 0 {
	False
} else {
	is_even(n - 1)
}

expect is_even(0)
expect is_odd(1)
expect is_even(10_000)
expect !is_odd(10_000)
### end snippet example
