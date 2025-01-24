app [main!] { cli: platform "../../../basic-cli/platform/main.roc" }

import cli.Stdout
import Hello

main! = |_args|
    Stdout.line!(Hello.hello("World"))
