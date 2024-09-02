### start snippet header
app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br",
    unicode: "https://github.com/roc-lang/unicode/releases/download/0.1.2/vH5iqn04ShmqP-pNemgF773f86COePSqMWHzVGrAKNo.tar.br",
}
### end snippet header

import pf.Stdout
import Module

main =
    Stdout.line! (Inspect.toStr (Module.splitGraphemes "hello"))
