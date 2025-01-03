app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
    parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.9.0/w8YKp2YAgQt5REYk912HfKAHBjcXsrnvtjI0CBzoAT4.tar.br",
}

import cli.Stdout
import parser.Parser exposing [Parser, many, oneOf, map]
import parser.String exposing [parseStr, codeunit, anyCodeunit]

main! = \_args ->

    letters = try parseStr (many letter_parser) input_str

    msg =
        letters
        |> count_letter_a
        |> \count -> "I counted $(count) letter A's!"

    Stdout.line! msg

Letter : [A, B, C, Other]

input_str = "AAAiBByAABBwBtCCCiAyArBBx"

# Helper to check if a letter is an A tag
isA = \l -> l == A

# Count the number of Letter A's
count_letter_a : List Letter -> Str
count_letter_a = \letters ->
    letters
    |> List.countIf isA
    |> Num.toStr

# Parser to convert utf8 input into Letter tags
letter_parser : Parser (List U8) Letter
letter_parser =
    oneOf [
        codeunit 'A' |> map \_ -> A,
        codeunit 'B' |> map \_ -> B,
        codeunit 'C' |> map \_ -> C,
        anyCodeunit |> map \_ -> Other,
    ]

# Test we can parse a single B letter
expect
    input = "B"
    parser = letter_parser
    result = parseStr parser input
    result == Ok B

# Test we can parse a number of different letters
expect
    input = "BCXA"
    parser = many letter_parser
    result = parseStr parser input
    result == Ok [B, C, Other, A]
