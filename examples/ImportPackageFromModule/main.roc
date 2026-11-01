### start snippet header
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.26.0/GddgvsGjiNXrHFW6au5i5dUDbTs8FinQdrgE2Gqmw53t.tar.zst",
	roc: "nightly-2026-11-01-48d3369",
	unicode: "https://github.com/roc-lang/unicode/releases/download/4.3.1/BNmth7q83JT3Pc2neutkWibVwFwNNNBLhhKfZhmDREeL.tar.zst",
}

### end snippet header

import cli.Stdout
import Module

main! = |_args| {
	Module.split_graphemes("hello")
		|> Str.inspect
		|> Stdout.line!
}
