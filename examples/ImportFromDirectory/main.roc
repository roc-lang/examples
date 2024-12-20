app [main!] { pf: platform "../../../basic-cli/platform/main.roc" }

import pf.Stdout
import Dir.Hello exposing [hello]

main! = \_ ->
    # here we're calling the `hello` function from the Hello module
    Stdout.line! (hello "World")
