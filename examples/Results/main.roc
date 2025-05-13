app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
}

import cli.Stdout
import cli.Arg exposing [Arg]

Person : { first_name : Str, last_name : Str, birth_year : U16 }

## This function parses strings like "{FirstName} {LastName} was born in {Year}"
## and if successful returns `Ok {first_name, last_name, birth_year}`. Otherwise
## it returns an `Err` containing a descriptive tag.
## This is the most verbose version, we will do better below.
parse_verbose : Str -> Result Person [InvalidRecordFormat, InvalidNameFormat, InvalidBirthYearFormat]
parse_verbose = |line|
    when line |> Str.split_first(" was born in ") is
        Ok({ before: full_name, after: birth_year_str }) ->
            when full_name |> Str.split_first(" ") is
                Ok({ before: first_name, after: last_name }) ->
                    when Str.to_u16(birth_year_str) is
                        Ok(birth_year) ->
                            Ok({ first_name, last_name, birth_year })

                        Err(_) -> Err(InvalidBirthYearFormat)

                _ -> Err(InvalidNameFormat)

        _ -> Err(InvalidRecordFormat)

## Here's a very slightly shorter version using `Result.try` to chain multiple
## functions that each could return an error. It's a bit nicer, don't you think?
parse_with_try : Str -> Result Person [InvalidNumStr, NotFound]
parse_with_try = |line|
    line
    |> Str.split_first(" was born in ")
    |> Result.try(
        |{ before: full_name, after: birth_year_str }|
            full_name
            |> Str.split_first(" ")
            |> Result.try(
                |{ before: first_name, after: last_name }|
                    Str.to_u16(birth_year_str)
                    |> Result.try(
                        |birth_year|
                            Ok({ first_name, last_name, birth_year }),
                    ),
            ),
    )

## This version is like `parse_with_try`, except it uses `Result.map_err`
## to return more informative errors, just like the ones in `parse_verbose`.
parse_with_try_v2 : Str -> Result Person [InvalidRecordFormat, InvalidNameFormat, InvalidBirthYearFormat]
parse_with_try_v2 = |line|
    line
    |> Str.split_first(" was born in ")
    |> Result.map_err(|_| InvalidRecordFormat)
    |> Result.try(
        |{ before: full_name, after: birth_year_str }|
            full_name
            |> Str.split_first(" ")
            |> Result.map_err(|_| InvalidNameFormat)
            |> Result.try(
                |{ before: first_name, after: last_name }|
                    Str.to_u16(birth_year_str)
                    |> Result.map_err(|_| InvalidBirthYearFormat)
                    |> Result.try(
                        |birth_year|
                            Ok({ first_name, last_name, birth_year }),
                    ),
            ),
    )

## The `?` operator, called the "try operator", is
## [syntactic sugar](en.wikipedia.org/wiki/Syntactic_sugar) for `Result.try`.
## It makes the code much less nested and easier to read.
## The following function is equivalent to `parse_with_try`:
parse_with_try_op : Str -> Result Person [NotFound, InvalidNumStr]
parse_with_try_op = |line|
    { before: full_name, after: birth_year_str } = Str.split_first(line, " was born in ")?
    { before: first_name, after: last_name } = Str.split_first(full_name, " ")?
    birth_year = Str.to_u16(birth_year_str)?

    Ok({ first_name, last_name, birth_year })

## And lastly the following function is equivalent to `parse_with_try_v2`.
## Note that the `?` operator has moved from `split_first` & `to_u16` to `map_err`:
parse_with_try_op_v2 : Str -> Result Person [InvalidRecordFormat, InvalidNameFormat, InvalidBirthYearFormat]
parse_with_try_op_v2 = |line|
    { before: full_name, after: birth_year_str } =
        (Str.split_first(line, " was born in ") |> Result.map_err(|_| InvalidRecordFormat))?

    { before: first_name, after: last_name } =
        (Str.split_first(full_name, " ") |> Result.map_err(|_| InvalidNameFormat))?

    birth_year = Result.map_err(Str.to_u16(birth_year_str), |_| InvalidBirthYearFormat)?

    Ok({ first_name, last_name, birth_year })

## This function parses a string using a given parser and returns a string to
## display to the user. Note how we can handle errors individually or in bulk.
parse = |line, parser|
    when parser(line) is
        Ok({ first_name, last_name, birth_year }) ->
            """
            Name: ${last_name}, ${first_name}
            Born:  ${Num.to_str(birth_year)}

            """

        Err(InvalidNameFormat) -> "What kind of a name is this?"
        Err(InvalidBirthYearFormat) -> "That birth year looks fishy."
        Err(InvalidRecordFormat) -> "Oh wow, that's a weird looking record!"
        _ -> "Something unexpected happened" # Err NotFound or Err InvalidNumStr

main! : List Arg => Result {} _
main! = |_args|
    Stdout.line!(parse("George Harrison was born in 1943", parse_verbose))?
    Stdout.line!(parse("John Lennon was born in 1940", parse_with_try))?
    Stdout.line!(parse("Paul McCartney was born in 1942", parse_with_try_v2))?
    Stdout.line!(parse("Ringo Starr was born in 1940", parse_with_try_op))?
    Stdout.line!(parse("Stuart Sutcliffe was born in 1940", parse_with_try_op_v2))?

    Ok({})

expect parse("George Harrison was born in 1943", parse_verbose) == "Name: Harrison, George\nBorn:  1943\n"
expect parse("John Lennon was born in 1940", parse_with_try) == "Name: Lennon, John\nBorn:  1940\n"
expect parse("Paul McCartney was born in 1942", parse_with_try_v2) == "Name: McCartney, Paul\nBorn:  1942\n"
expect parse("Ringo Starr was born in 1940", parse_with_try_op) == "Name: Starr, Ringo\nBorn:  1940\n"
expect parse("Stuart Sutcliffe was born in 1940", parse_with_try_op_v2) == "Name: Sutcliffe, Stuart\nBorn:  1940\n"
