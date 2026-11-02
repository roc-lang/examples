app [main!] {
	roc: "nightly-2026-11-02-847b82c",
}

### start snippet example
import Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Hello module
	echo!(hello("World"))
	Ok({})
}
### end snippet example
