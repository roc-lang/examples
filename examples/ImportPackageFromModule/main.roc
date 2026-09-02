### start snippet header
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.0/F1JVZPYfWP71s8vk6tHcV1Qx1Ef6CZkwswGoCn8VHZmL.tar.zst",
	unicode: "https://github.com/roc-lang/unicode/releases/download/2.0.0/9ZvqNzsNkpqFmGTeATAY3BNBD7mP41jqZx2w2N19tBvh.tar.zst",
	roc: "nightly-2026-09-02-d2609e2",
}

### end snippet header

import cli.Stdout
import Module

main! = |_args| {
	Module.split_graphemes("hello")
		|> Str.inspect
		|> Stdout.line!
}
