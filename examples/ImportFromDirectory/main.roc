app [main!] {
	roc: "nightly-2026-11-10-f7d1f19",
}

### start snippet example
import Dir/Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Dir.Hello module
	echo!(hello("World"))
	Ok({})
}
### end snippet example
