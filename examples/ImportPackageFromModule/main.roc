### start snippet header
app [main!] {
    pf: platform "../../../basic-cli/platform/main.roc",
    unicode: "https://github.com/roc-lang/unicode/releases/download/0.1.2/vH5iqn04ShmqP-pNemgF773f86COePSqMWHzVGrAKNo.tar.br",
}
### end snippet header

import pf.Stdout
import Module

main! = \_ ->
    Stdout.line! (Inspect.toStr (Module.split_graphemes "hello"))
