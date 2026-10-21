app [main!] {
	roc: "nightly-2026-10-21-5349569",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
