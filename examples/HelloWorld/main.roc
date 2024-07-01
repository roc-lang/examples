app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/cf_TpThUd4e69C7WzHxCbgsagnDmk3xlb_HmEKXTICw.tar.br" }

import pf.Stdout
import pf.Task

main =
    Stdout.line! "Hello, World!"
