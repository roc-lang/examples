app "interface-modules"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.9.1/y_Ww7a2_ZGjp0ZTt9Y_pNdSqqMRdMLzHMKfdN8LWidk.tar.br" }
    # we import Stdout from the platform and the Hello interface from the Hello.roc file
    imports [pf.Stdout, Hello]
    provides [main] to pf

main = Stdout.line (Hello.hello "World")
