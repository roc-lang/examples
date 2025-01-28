app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import Dir.Hello exposing [hello]

main! = |_args|
    # here we're calling the `hello` function from the Hello module
    Stdout.line!(hello("World"))
