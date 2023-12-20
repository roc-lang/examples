app "hello-world"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" }
    # The next line import Stdout from the platform and the Hello interface from the Hello.roc file
    imports [pf.Stdout, Hello]
    provides [main] to pf

main = Stdout.line (Hello.hello "World")
