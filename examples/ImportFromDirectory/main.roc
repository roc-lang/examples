app [main!] {
	roc: "nightly-2026-11-13-03dce41",
}

### start snippet example
import Dir/Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Dir.Hello module
	echo!(hello("World"))
	Ok({})
}
### end snippet example
