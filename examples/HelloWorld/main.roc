app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0-testing/libzR-AkVEn_dTBg2bKuXqMNZ9rYEfz3HSEQU8inoGk.tar.br" }

import pf.Stdout
import pf.Task

main =
    Stdout.line! "Hello, World!"
