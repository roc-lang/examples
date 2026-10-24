app [main!] {
	roc: "nightly-2026-10-24-f6c6cfb",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
