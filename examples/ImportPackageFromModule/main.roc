### start snippet header
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.28.1/7brgwR8YUqfeGrkdfF1V4GPPN7DnP7ftqub9KcrTEZtr.tar.zst",
	roc: "0.1.0-RC1",
	unicode: "https://github.com/roc-lang/unicode/releases/download/4.3.3/AJfFMmhvmbgn7THAF1E1sofC3dZaVWPFmVV7GH8Bc7k7.tar.zst",
}

### end snippet header

import cli.Stdout
import Module

main! = |_args| {
	Module.split_graphemes("hello")
		|> Str.inspect
		|> Stdout.line!
}
