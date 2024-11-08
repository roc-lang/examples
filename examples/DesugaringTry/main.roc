app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.16.0/O00IPk-Krg_diNS2dVWlI0ZQP794Vctxzv0ha96mK0E.tar.br" }

import pf.Stdout

main =
    Stdout.line! (Inspect.toStr (parseNameAndYear "Alice was born in 1990"))
    Stdout.line! (Inspect.toStr (parseNameAndYearTry "Alice was born in 1990"))

### start snippet question
parseNameAndYear : Str -> Result { name : Str, birthYear : U16 } _
parseNameAndYear = \str ->
    { before: name, after: birthYearStr } = Str.splitFirst? str " was born in "
    birthYear = Str.toU16? birthYearStr
    Ok { name, birthYear }
### end snippet question

parseNameAndYearTry = \str ->
    ### start snippet try
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
