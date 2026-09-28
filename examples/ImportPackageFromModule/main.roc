### start snippet header
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.23.0/GNN5tt2gKdX4dhawg4915C4YB193woHFdcCkz31fhGxv.tar.zst",
	unicode: "https://github.com/roc-lang/unicode/releases/download/2.0.0/9ZvqNzsNkpqFmGTeATAY3BNBD7mP41jqZx2w2N19tBvh.tar.zst",
	roc: "nightly-2026-09-27-a3ce7f1",
}

### end snippet header

import cli.Stdout
import Module

main! = |_args| {
	Module.split_graphemes("hello")
		|> Str.inspect
		|> Stdout.line!
}
