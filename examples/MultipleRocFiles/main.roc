app [main!] {
	roc: "nightly-2026-10-17-5f126ac",
}

import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
