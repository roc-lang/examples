### start snippet header
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.24.0/AEjfyaMFFbh8FJrkkHJy68riVNPr3Qp6c6PawWQjBwMH.tar.zst",
	roc: "nightly-2026-10-04-130536d",
	unicode: "https://github.com/roc-lang/unicode/releases/download/4.2.0/4W8SHzvwet9hH9qZewJ1J1CVQoH7YKA6zyijWFTB3y1w.tar.zst",
}

### end snippet header

import cli.Stdout
import Module

main! = |_args| {
	Module.split_graphemes("hello")
		|> Str.inspect
		|> Stdout.line!
}
