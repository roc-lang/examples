app [main!] {
	roc: "nightly-2026-10-09-258ab27",
}

import "sample.txt" as sample : Str

main! = |_| {
	echo!("Contents of sample.txt: ${sample}\n")
	Ok({})
}
