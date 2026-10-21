app [main!] {
	roc: "nightly-2026-10-20-7a8a800",
}

import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
