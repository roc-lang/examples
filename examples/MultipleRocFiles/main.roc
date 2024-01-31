app "interface-modules"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    # we import Stdout from the platform and the Hello interface from the Hello.roc file
    imports [pf.Stdout, Hello]
    provides [main] to pf

main = Stdout.line (Hello.hello "World")
