app [main!] { pf: platform "../../../basic-cli/platform/main.roc" }

import pf.Stdout
import Hello

main! = \_ ->
    Stdout.line! (Hello.hello "World")
