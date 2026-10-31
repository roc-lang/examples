app [] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
make_adder : I64 -> (I64 -> I64)
make_adder = |amount| |n| n + amount

add_ten = make_adder(10)

add_twenty = make_adder(20)

expect add_ten(3) == 13
expect add_twenty(3) == 23
expect [1, 2, 3].map(add_ten) == [11, 12, 13]
### end snippet example
