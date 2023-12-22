app "ingested-file"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" }
    imports [
        pf.Stdout,
        "sample.txt" as sample : Str,
    ]
    provides [main] to pf

main =
    Stdout.line "\(sample)"
