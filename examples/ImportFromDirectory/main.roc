app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.13.0/zsDHOdxyAcj6EhyNZx_3qhIICVlnho-OZ5X2lFDLi0k.tar.br" }

import pf.Stdout
import pf.Task
import Dir.Hello exposing [hello]

main =
    Stdout.line! (hello "World")
