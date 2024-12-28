app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br" }

import pf.Stdout
import Dir.Hello exposing [hello]

main! = \_ ->
    # here we're calling the `hello` function from the Hello module
    Stdout.line! (hello "World")
