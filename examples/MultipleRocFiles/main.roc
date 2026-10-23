app [main!] {
	roc: "nightly-2026-10-21-5349569",
}

import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
