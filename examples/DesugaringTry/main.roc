app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/bi5zubJ-_Hva9vxxPq4kNx4WHX6oFs8OP6Ad0tCYlrY.tar.br" }

import cli.Stdout

main! = |_args|
    Stdout.line!(Inspect.to_str(parse_name_and_year("Alice was born in 1990")))?
    Stdout.line!(Inspect.to_str(parse_name_and_year_try("Alice was born in 1990")))?

    Ok({})

### start snippet question
parse_name_and_year : Str -> Result { name : Str, birth_year : U16 } _
parse_name_and_year = |str|
    { before: name, after: birth_year_str } = Str.split_first(str, " was born in ")?
    birth_year = Str.to_u16(birth_year_str)?
    Ok({ name, birth_year })
### end snippet question

parse_name_and_year_try = |str|
    ### start snippet try
    when Str.split_first(str, " was born in ") is
        Err(err1) -> return Err(err)
        Ok({ before: name, after: birth_year_str }) ->
            when Str.to_u16(birth_year_str)? is
                Err(err2) -> return Err(err2)
                Ok(birth_year) ->
                    Ok({ name, birth_year })
### end snippet try

expect parse_name_and_year("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
expect parse_name_and_year_try("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
