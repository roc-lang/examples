app [main!] { cli: platform "../../../basic-cli/platform/main.roc" }

import cli.Stdout
import "sample.txt" as sample : Str

main! = \_args ->
    Stdout.line!("${sample}")
