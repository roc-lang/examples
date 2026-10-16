app [main!] {
	roc: "nightly-2026-10-16-f14c106",
}

import Dir/Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Dir.Hello module
	echo!(hello("World"))
	Ok({})
}
