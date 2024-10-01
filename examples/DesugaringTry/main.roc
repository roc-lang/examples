app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br" }

import pf.Stdout

main =
    Stdout.line! (Inspect.toStr (parseNameAndYear "Alice was born in 1990"))
    Stdout.line! (Inspect.toStr (parseNameAndYearTry "Alice was born in 1990"))

### begin snippet question
parseNameAndYear : Str -> Result { name : Str, birthYear : U16 } _
parseNameAndYear = \str ->
    { before: name, after: birthYearStr } = Str.splitFirst? str " was born in "
    birthYear = Str.toU16? birthYearStr
    Ok { name, birthYear }
### end snippet question

parseNameAndYearTry = \str ->
    ### begin snippet try
    str
    |> Str.splitFirst " was born in "
    |> Result.try \{ before: name, after: birthYearStr } ->
        Str.toU16 birthYearStr
        |> Result.try \birthYear ->
            Ok { name, birthYear }
### end snippet try

expect
    parseNameAndYear "Alice was born in 1990" == Ok { name: "Alice", birthYear: 1990 }

expect
    parseNameAndYearTry "Alice was born in 1990" == Ok { name: "Alice", birthYear: 1990 }
