app [transform] {
	pf: platform "platform/main.roc",
	roc: "nightly-2026-10-14-38a3029",
}

transform : I64 -> I64
transform = |n| n + 1

expect transform(41) == 42
