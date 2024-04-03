app "rocLovesGo"
    packages { pf: "platform/main.roc" }
    imports []
    provides [main] to pf

# Can segfault on some Ubuntu 20.04 CI machines, see #164.
main = "Roc <3 Go!\n"
