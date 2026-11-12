### start snippet header
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.28.0/2yhxoR7cZPSYbyUzPWULFw8AA6QEcdsgFNRmzu7pZbst.tar.zst",
	roc: "nightly-2026-11-12-ce942d6",
	unicode: "https://github.com/roc-lang/unicode/releases/download/4.3.2/3gvgiWm6BShjHKbNV2zRH6fhC5ZvScZgWF7AnVDWHSdd.tar.zst",
}

### end snippet header

import cli.Stdout
import Module

main! = |_args| {
	Module.split_graphemes("hello")
		|> Str.inspect
		|> Stdout.line!
}
