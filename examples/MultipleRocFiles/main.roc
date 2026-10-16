app [main!] {
	roc: "nightly-2026-10-15-38e6c42",
}

import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
