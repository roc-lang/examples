app [main!] {
	roc: "nightly-2026-10-15-38e6c42",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
