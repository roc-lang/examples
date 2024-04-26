app "hello-world"
    packages { pf: "../../../basic-cli/platform/main.roc" }
    imports [pf.Stdout, pf.Task]
    provides [main] to pf

main = 
    Stdout.line! "Hello, World!"
