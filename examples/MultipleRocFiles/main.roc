app "interface-modules"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.1/Icc3xJoIixF3hCcfXrDwLCu4wQHtNdPyoJkEbkgIElA.tar.br" }
    # we import Stdout from the platform and the Hello interface from the Hello.roc file
    imports [pf.Stdout, Hello]
    provides [main] to pf

main = Stdout.line (Hello.hello "World")
