app [main!] {
	roc: "nightly-2026-11-01-48d3369",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
