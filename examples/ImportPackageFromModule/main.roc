### start snippet header
app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
    unicode: "https://github.com/roc-lang/unicode/releases/download/0.3.0/9KKFsA4CdOz0JIOL7iBSI_2jGIXQ6TsFBXgd086idpY.tar.br",
}
### end snippet header

import cli.Stdout
import cli.Arg exposing [Arg]
import Module

main! : List Arg => Result {} _
main! = |_args|
    Module.split_graphemes("hello")
    |> Inspect.to_str
    |> Stdout.line!
