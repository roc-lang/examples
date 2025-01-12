app [main!] { cli: platform "../../../basic-cli/platform/main.roc" }

import cli.Stdout

main! = \_args ->
    Stdout.line!(Inspect.to_str(parse_name_and_year("Alice was born in 1990")))?
    Stdout.line!(Inspect.to_str(parse_name_and_year_try("Alice was born in 1990")))?

    Ok({})

### start snippet question
parse_name_and_year : Str -> Result { name : Str, birth_year : U16 } _
parse_name_and_year = \str ->
    { before: name, after: birth_year_str } = Str.split_first(str, " was born in ")?
    birth_year = Str.to_u16(birth_year_str)?
    Ok({ name, birth_year })
### end snippet question

parse_name_and_year_try = \str ->
    ### start snippet try
    str
    |> Str.split_first(" was born in ")
    |> Result.try(
        \{ before: name, after: birth_year_str } ->
            Str.to_u16(birth_year_str)
            |> Result.try(
                \birth_year ->
                    Ok({ name, birth_year }),
            ),
    )
### end snippet try

expect parse_name_and_year("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
expect parse_name_and_year_try("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
