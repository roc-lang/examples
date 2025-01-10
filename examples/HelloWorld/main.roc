app [main!] { cli: platform "../../../basic-cli/platform/main.roc" }

import cli.Stdout

main! = \_args ->
    Stdout.line!("Hello, World!")
