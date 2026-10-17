app [main!] {
	roc: "nightly-2026-10-16-f14c106",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
