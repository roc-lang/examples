app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
    parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/0.10.0/6eZYaXkrakq9fJ4oUc0VfdxU1Fap2iTuAN18q9OgQss.tar.br",
}

import cli.Stdout
import cli.Arg exposing [Arg]
import parser.Parser exposing [Parser, many, one_of, map]
import parser.String exposing [parse_str, codeunit, any_codeunit]

main! : List Arg => Result {} _
main! = |_args|

    letters = parse_str(many(letter_parser), input_str)?

    msg =
        letters
        |> count_letter_a
        |> |count| "I counted ${count} letter A's!"

    Stdout.line!(msg)

Letter : [A, B, C, Other]

input_str = "AAAiBByAABBwBtCCCiAyArBBx"

# Count the number of Letter A's
count_letter_a : List Letter -> Str
count_letter_a = |letters|
    letters
    |> List.count_if(|l| l == A)
    |> Num.to_str

# Parser to convert utf8 input into Letter [tags](https://www.roc-lang.org/tutorial#tags)
letter_parser : Parser (List U8) Letter
letter_parser =
    one_of(
        [
            codeunit('A') |> map(|_| A),
            codeunit('B') |> map(|_| B),
            codeunit('C') |> map(|_| C),
            any_codeunit |> map(|_| Other),
        ],
    )

# Test parsing a single letter B
expect
    input = "B"
    parser = letter_parser
    result = parse_str(parser, input)
    result == Ok(B)

# Test parsing a number of different letters
expect
    input = "BCXA"
    parser = many(letter_parser)
    result = parse_str(parser, input)
    result == Ok([B, C, Other, A])
