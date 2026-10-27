app [] {
	roc: "nightly-2026-10-27-de79a0f",
}

### start snippet example
positive : Try(I64, [BadNumber, NotPositive]) -> Try(I64, [BadNumber, NotPositive])
positive = |input| match input {
	Ok(n) as result => if n > 0 {
		result
	} else {
		Err(NotPositive)
	}
	Err(_) as result => result
}

expect positive(Ok(3)) == Ok(3)
expect positive(Ok(0)) == Err(NotPositive)
expect positive(Err(BadNumber)) == Err(BadNumber)
### end snippet example
