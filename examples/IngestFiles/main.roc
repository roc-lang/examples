app [main!] { pf: platform "../../../basic-cli/platform/main.roc" }

import pf.Stdout
import "sample.txt" as sample : Str

main! = \_ ->
    Stdout.line! "$(sample)"
