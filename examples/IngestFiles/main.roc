app [main!] {
	roc: "nightly-2026-10-18-1df370f",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
