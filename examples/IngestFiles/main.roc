app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/Lb8EgiejTUzbggO2HVVuPJFkwvvsfW6LojkLR20kTVE.tar.br" }

import pf.Stdout
import pf.Task
import "sample.txt" as sample : Str

main =
    Stdout.line! "$(sample)"
