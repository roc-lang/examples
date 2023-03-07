app "example"
    packages {
        cli: "https://github.com/roc-lang/basic-cli/releases/download/0.2.1/wx1N6qhU3kKva-4YqsVJde3fho34NqiLD3m620zZ-OI.tar.br",
        parser: "../packages/parser/main.roc",
    }
    imports [
        cli.Stdout,
        parser.ParserCore.{ Parser, buildPrimitiveParser, many },
        parser.ParserStr.{ parseStr },
    ]
    provides [main] to cli

main =
    many letterParser
    |> parseStr inputStr
    |> Result.onErr \_ -> crash "Ooops, something went wrong parsing"
    |> Result.map countLetterAs
    |> Result.map \count -> "I counted \(count) letter A's!"
    |> Result.withDefault ""
    |> Stdout.line

Letter : [A, B, C, Other]

inputStr = "AAAiBByAABBwBtCCCiAyArBBx"

# Helper to check if a letter is an A tag 
isA = \l -> l == A

# Count the number of Letter A's
countLetterAs : List Letter -> Str
countLetterAs = \letters -> 
    letters
    |> List.keepIf isA
    |> List.map \_ -> 1
    |> List.sum
    |> Num.toStr

# Build a custom parser to convert utf8 input into Letter tags
letterParser : Parser (List U8) Letter
letterParser =
    input <- buildPrimitiveParser

    valResult = when input is
        [] -> Err (ParsingFailure "Nothing to parse")
        ['A', ..] -> Ok A
        ['B', ..] -> Ok B
        ['C', ..] -> Ok C
        _ -> Ok Other

    valResult
    |> Result.map \val -> { val, input: List.dropFirst input }

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
