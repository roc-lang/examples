app "interface-modules"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br" }
    # we import Stdout from the platform and the Hello interface from the Hello.roc file
    imports [pf.Stdout, pf.Task, Hello]
    provides [main] to pf

main =
    Stdout.line! (Hello.hello "World")
