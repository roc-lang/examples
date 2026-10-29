app [main!] {
	roc: "nightly-2026-10-29-a0a9fc2",
}

import Dir/Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Dir.Hello module
	echo!(hello("World"))
	Ok({})
}
