app "rocLovesGo"
    packages {pf: "platform/main.roc"}
    imports []
    provides [main] to pf

main = "hello world\n"
