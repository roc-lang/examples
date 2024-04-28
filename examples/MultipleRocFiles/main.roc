app "interface-modules"
    packages { pf: "../../../basic-cli/platform/main.roc" }
    # we import Stdout from the platform and the Hello interface from the Hello.roc file
    imports [pf.Stdout, pf.Task, Hello]
    provides [main] to pf

main =
    Stdout.line! (Hello.hello "World")
