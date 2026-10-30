app [main!] {
	roc: "nightly-2026-10-30-0602c5f",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
