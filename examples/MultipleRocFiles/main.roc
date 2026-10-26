app [main!] {
	roc: "nightly-2026-10-26-3c0fffe",
}

import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
