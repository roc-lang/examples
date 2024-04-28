app "ingested-file"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
        "sample.txt" as sample : Str,
    ]
    provides [main] to pf

main =
    Stdout.line! "$(sample)"
