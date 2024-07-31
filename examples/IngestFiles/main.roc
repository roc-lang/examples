app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.13.0/nW9yMRtZuCYf1Oa9vbE5XoirMwzLbtoSgv7NGhUlqYA.tar.br" }

import pf.Stdout
import pf.Task
import "sample.txt" as sample : Str

main =
    Stdout.line! "$(sample)"
