app [main!] {
	roc: "nightly-2026-10-26-3c0fffe",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
