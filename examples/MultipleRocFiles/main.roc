app [main!] {
	roc: "nightly-2026-11-14-a87808d",
}

### start snippet example
import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
### end snippet example
