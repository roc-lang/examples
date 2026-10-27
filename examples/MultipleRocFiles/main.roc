app [main!] {
	roc: "nightly-2026-10-27-de79a0f",
}

import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
