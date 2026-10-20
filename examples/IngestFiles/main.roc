app [main!] {
	roc: "nightly-2026-10-20-7a8a800",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
