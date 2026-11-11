app [main!] {
	roc: "nightly-2026-11-11-7679cc5",
}

### start snippet example
import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
### end snippet example
