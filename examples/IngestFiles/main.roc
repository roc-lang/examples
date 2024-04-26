app "ingested-file"
    packages { pf: "../../../basic-cli/platform/main.roc" }
    imports [
        pf.Stdout,
        pf.Task,
        "sample.txt" as sample : Str,
    ]
    provides [main] to pf

main =
    Stdout.line! "$(sample)"
