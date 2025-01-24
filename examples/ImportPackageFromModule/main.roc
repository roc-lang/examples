### start snippet header
app [main!] {
    cli: platform "../../../basic-cli/platform/main.roc",
    unicode: "https://github.com/roc-lang/unicode/releases/download/0.1.2/vH5iqn04ShmqP-pNemgF773f86COePSqMWHzVGrAKNo.tar.br",
}
### end snippet header

import cli.Stdout
import Module

main! = |_args|
    Module.split_graphemes("hello")
    |> Inspect.to_str
    |> Stdout.line!
