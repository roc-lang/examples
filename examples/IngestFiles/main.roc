app [main!] {
	roc: "nightly-2026-10-27-de79a0f",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
