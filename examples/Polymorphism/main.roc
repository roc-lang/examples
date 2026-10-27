app [] {
	roc: "nightly-2026-10-27-de79a0f",
}

### start snippet example
duplicate : a -> (a, a)
duplicate = |value| (value, value)

show : a -> Str where [a.to_str : a -> Str]
show = |value| value.to_str()

a.Showable : where [a.to_str : a -> Str]

show_pair : a, a -> Str where [a.Showable]
show_pair = |left, right| "${left.to_str()}, ${right.to_str()}"

expect duplicate(7.U8) == (7, 7)
expect duplicate("Roc") == ("Roc", "Roc")
expect show(42.U64) == "42"
expect show_pair(2.I64, 3.I64) == "2, 3"
### end snippet example
