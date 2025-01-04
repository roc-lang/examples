app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br" }

import pf.Stdout

main! = \_args ->
    try Stdout.line! (Inspect.toStr (parse_name_and_year "Alice was born in 1990"))
    try Stdout.line! (Inspect.toStr (parse_name_and_year_try "Alice was born in 1990"))

    Ok {}

### start snippet question
parse_name_and_year : Str -> Result { name : Str, birth_year : U16 } _
parse_name_and_year = \str ->
    { before: name, after: birth_year_str } = Str.splitFirst? str " was born in "
    birth_year = Str.toU16? birth_year_str
    Ok { name, birth_year }
### end snippet question

parse_name_and_year_try = \str ->
    ### start snippet try
    str
    |> Str.splitFirst " was born in "
    |> Result.try \{ before: name, after: birth_year_str } ->
        Str.toU16 birth_year_str
        |> Result.try \birth_year ->
            Ok { name, birth_year }
### end snippet try

expect
    parse_name_and_year "Alice was born in 1990" == Ok { name: "Alice", birth_year: 1990 }

expect
    parse_name_and_year_try "Alice was born in 1990" == Ok { name: "Alice", birth_year: 1990 }
