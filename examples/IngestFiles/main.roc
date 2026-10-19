app [main!] {
	roc: "nightly-2026-10-17-5f126ac",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
