app [] {
	roc: "nightly-2026-11-01-48d3369",
}

### start snippet example
first_three : List(U64)
first_three = (1..<1_000_000).iter()
	.keep_if(|n| n % 2 == 0)
	.map(|n| n * 10)
	.take_first(3)
	.collect()

backwards : List(I64)
backwards = (1.I64..=8).step_by(2).iter_rev().collect()

countdown : U64 -> Iter(U64)
countdown = |start| Iter.custom(
	start,
	Known(start),
	|n| {
		if n == 0 {
			Err(NoMore)
		} else {
			Ok((n, n - 1))
		}
	},
)

expect first_three == [20, 40, 60]
expect backwards == [7, 5, 3, 1]
expect List.from_iter(countdown(3)) == [3, 2, 1]
expect List.from_iter(countdown(0)) == []
### end snippet example
