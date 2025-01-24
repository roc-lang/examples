app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/bi5zubJ-_Hva9vxxPq4kNx4WHX6oFs8OP6Ad0tCYlrY.tar.br" }

import cli.Stdout
import Hello

main! = |_args|
    Stdout.line!(Hello.hello("World"))
