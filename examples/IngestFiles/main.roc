app [main!] {
	roc: "nightly-2026-10-25-72704da",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
