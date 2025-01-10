app [main!] {
    # TODO replace with release URL
    cli: platform "../../../basic-cli/platform/main.roc",
    # TODO replace with release URL
    parser: "../../../roc-parser/package/main.roc",
}

import cli.Stdout
import parser.Parser exposing [Parser, many, one_of, map]
import parser.String exposing [parse_str, codeunit, any_codeunit]

main! = \_args ->

    letters = parse_str(many(letter_parser), input_str)?

    msg =
        letters
        |> count_letter_a
        |> \count -> "I counted $(count) letter A's!"

    Stdout.line!(msg)

Letter : [A, B, C, Other]

input_str = "AAAiBByAABBwBtCCCiAyArBBx"

# Count the number of Letter A's
count_letter_a : List Letter -> Str
count_letter_a = \letters ->
    letters
    |> List.count_if(\l -> l == A)
    |> Num.to_str

# Parser to convert utf8 input into Letter tags
letter_parser : Parser (List U8) Letter
letter_parser =
    one_of(
        [
            codeunit('A') |> map(\_ -> A),
            codeunit('B') |> map(\_ -> B),
            codeunit('C') |> map(\_ -> C),
            any_codeunit |> map(\_ -> Other),
        ],
    )

# Test we can parse a single B letter
expect
    input = "B"
    parser = letter_parser
    result = parse_str(parser, input)
    result == Ok(B)

# Test we can parse a number of different letters
expect
    input = "BCXA"
    parser = many(letter_parser)
    result = parse_str(parser, input)
    result == Ok([B, C, Other, A])
