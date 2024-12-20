app [main!] { pf: platform "../../../basic-cli/platform/main.roc" }

import pf.Stdout

main! = \_ ->
    Stdout.line! "Hello, World!"
