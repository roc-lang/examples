app [main!] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
import Dir/Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Dir.Hello module
	echo!(hello("World"))
	Ok({})
}
### end snippet example
