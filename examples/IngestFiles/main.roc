app [main!] {
	roc: "nightly-2026-10-29-a0a9fc2",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
