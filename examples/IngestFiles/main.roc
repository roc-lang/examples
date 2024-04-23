app "ingested-file"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.9.1/y_Ww7a2_ZGjp0ZTt9Y_pNdSqqMRdMLzHMKfdN8LWidk.tar.br" }
    imports [
        pf.Stdout,
        "sample.txt" as sample : Str,
    ]
    provides [main] to pf

main =
    Stdout.line "$(sample)"
