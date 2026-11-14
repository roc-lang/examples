app [main!] {
	roc: "nightly-2026-11-14-a87808d",
}

### start snippet example
import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
### end snippet example
