app [main] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/Lb8EgiejTUzbggO2HVVuPJFkwvvsfW6LojkLR20kTVE.tar.br",
    parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.7.1/MvLlME9RxOBjl0QCxyn3LIaoG9pSlaNxCa-t3BfbPNc.tar.br",
}

import cli.Stdout
import cli.Task
import parser.Core exposing [Parser, many, oneOf, map]
import parser.String exposing [parseStr, codeunit, anyCodeunit]

main =
    many letterParser
        |> parseStr inputStr
        |> Result.map countLetterAs
        |> Result.map \count -> "I counted $(count) letter A's!"
        |> Result.withDefault "Ooops, something went wrong parsing"
        |> Stdout.line!

Letter : [A, B, C, Other]

inputStr = "AAAiBByAABBwBtCCCiAyArBBx"

# Helper to check if a letter is an A tag
isA = \l -> l == A

# Count the number of Letter A's
countLetterAs : List Letter -> Str
countLetterAs = \letters ->
    letters
    |> List.countIf isA
    |> Num.toStr

# Parser to convert utf8 input into Letter tags
letterParser : Parser (List U8) Letter
letterParser =
    oneOf [
        codeunit 'A' |> map \_ -> A,
        codeunit 'B' |> map \_ -> B,
        codeunit 'C' |> map \_ -> C,
        anyCodeunit |> map \_ -> Other,
    ]

# Test we can parse a single B letter
expect
    input = "B"
    parser = letterParser
    result = parseStr parser input
    result == Ok B

# Test we can parse a number of different letters
expect
    input = "BCXA"
    parser = many letterParser
    result = parseStr parser input
    result == Ok [B, C, Other, A]
