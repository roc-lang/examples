app [main!] {
	roc: "nightly-2026-11-18-a520eed",
}

### start snippet example
import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
### end snippet example
