app "ingested-file"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [
        pf.Stdout,
        "sample.txt" as sample : Str,
    ]
    provides [main] to pf

main =
    Stdout.line "$(sample)"
