app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br" }

import cli.Stdout
import cli.Arg exposing [Arg]
import "sample.txt" as sample : Str

main! : List Arg => Result {} _
main! = |_args|
    Stdout.line!("Contents of sample.txt: ${sample}")
