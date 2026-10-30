app [main!] {
	roc: "nightly-2026-10-30-0602c5f",
}

import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
