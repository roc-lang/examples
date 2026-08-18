### start snippet header
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.21.0/4rAQg8kUYZ3Vksr4qMQHpaFYNiHSn9GgS7gVxghd1XYV.tar.zst",
	unicode: "https://github.com/roc-lang/unicode/releases/download/2.0.0/9ZvqNzsNkpqFmGTeATAY3BNBD7mP41jqZx2w2N19tBvh.tar.zst",
	roc: "nightly-2026-08-18-e9be50a",
}

### end snippet header

import cli.Stdout
import Module

main! = |_args| {
	Module.split_graphemes("hello")
		|> Str.inspect
		|> Stdout.line!
}
