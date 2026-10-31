app [main!] {
	roc: "nightly-2026-10-31-f7bef6b",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
