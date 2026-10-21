app [main!] {
	roc: "nightly-2026-10-19-601b54c",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
