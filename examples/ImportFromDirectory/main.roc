app [main!] {
	roc: "nightly-2026-11-03-34bd006",
}

### start snippet example
import Dir/Hello exposing [hello]

main! = |_args| {
	# here we're calling the `hello` function from the Dir.Hello module
	echo!(hello("World"))
	Ok({})
}
### end snippet example
