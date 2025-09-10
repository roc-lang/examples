app [main] { pf: platform "platform/main.roc" }

# Can segfault on some Ubuntu 20.04 CI machines, see github.com/roc-lang/examples/issues/164
main : Str
main = "Roc <3 Go!\n"
