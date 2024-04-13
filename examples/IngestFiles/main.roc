app "ingested-file"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.9.0/oKWkaruh2zXxin_xfsYsCJobH1tO8_JvNkFzDwwzNUQ.tar.br" }
    imports [
        pf.Stdout,
        "sample.txt" as sample : Str,
    ]
    provides [main] to pf

main =
    Stdout.line "$(sample)"
