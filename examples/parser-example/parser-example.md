# Parser Example

**URL Packages.** This application uses the `roc-lang/basic-cli` platform and a Parser package to demonstrate a how to build and use a custom parser to handle UTF8 input. It also demonstrates how Roc code can be organised into separate Interface modules and imported as a package.

You can run this example with `roc run hello-letters.roc`.

**Unit Testing.** This example also demonstrates how to create a unit test for a Roc module using the `expect` keyword. Unit tests are an excellent way to develop using test driven development, and also protect against any future regression in functionality. You can run the tests in this example usin the command `roc test hello-letters.roc`.

Below is an example of a unit test from the example.

```coffee
# Test we can parse a number of different letters
expect
    input = "BCXA"
    parser = many letterParser
    result = parseStr parser input
    result == Ok [B, C, Other, A]
```

**Documentation Comments.** This example shows how Roc code can be documented to communicate effectively with users of a package. The `/package/ParserCore.roc` Interface module has multiple examples of documentation comments. You can generate documentation using the Roc cli with the command `roc docs package/main.roc`. 

Below is an example of a documentation comment on a function.

```coffee
## Runs a parser for an 'opening' delimiter, then your main parser, then the 'closing' delimiter,
## and only returns the result of your main parser.
##
## Useful to recognize structures surrounded by delimiters (like braces, parentheses, quotes, etc.)
## ```
## betweenBraces  = \parser -> parser |> between (scalar '[') (scalar ']')
## ```
```

```roc
app "example"
    packages {
        cli: "https://github.com/roc-lang/basic-cli/releases/download/0.2.1/wx1N6qhU3kKva-4YqsVJde3fho34NqiLD3m620zZ-OI.tar.br",
        parser: "./package/main.roc",
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

```