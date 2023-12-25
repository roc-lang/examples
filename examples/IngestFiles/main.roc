app "ingested-file"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.1/Icc3xJoIixF3hCcfXrDwLCu4wQHtNdPyoJkEbkgIElA.tar.br" }
    imports [
        pf.Stdout,
        "sample.txt" as sample : Str,
    ]
    provides [main] to pf

main =
    Stdout.line "\(sample)"
