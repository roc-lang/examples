app [] {
	roc: "nightly-2026-10-14-38a3029",
}

### start snippet example
expect {
	width = U64.from_str("6")?
	height = U64.from_str("7")?
	width * height == 42
}

expect {
	values : List(U64)
	values = Json.parse("[2, 3, 5]")?
	values.sum() == 10
}

# Test an expected error directly instead of unwrapping it.
expect U64.from_str("six").is_err()
### end snippet example
