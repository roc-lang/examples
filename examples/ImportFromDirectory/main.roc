app [main!] { cli: platform "../../../basic-cli/platform/main.roc" }

import cli.Stdout
import Dir.Hello exposing [hello]

main! = \_args ->
    # here we're calling the `hello` function from the Hello module
    Stdout.line!(hello("World"))
