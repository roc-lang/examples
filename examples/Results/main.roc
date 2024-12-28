app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
}

import pf.Stdout

## This function parses strings like "{FirstName} {LastName} was born in {Year}"
## and if successful returns `Ok {firstName, lastName, birthYear}`. Otherwise
## it returns an `Err` containing a descriptive tag.
## This is the most verbose version, we will do better below.
parse_verbose = \line ->
    when line |> Str.splitFirst " was born in " is
        Ok { before: full_name, after: birth_year_str } ->
            when full_name |> Str.splitFirst " " is
                Ok { before: first_name, after: last_name } ->
                    when Str.toU16 birth_year_str is
                        Ok birth_year ->
                            Ok { first_name, last_name, birth_year }

                        Err _ -> Err InvalidBirthYearFormat

                _ -> Err InvalidNameFormat

        _ -> Err InvalidRecordFormat

## Here's a very slightly shorter version using `Result.try` to chain multiple
## functions that each could return an error. It's a bit nicer, don't you think?
## Note: this version returns "raw" errors (`Err NotFound` or `Err InvalidNumStr`).
parse_with_try = \line ->
    line
    |> Str.splitFirst " was born in "
    |> Result.try \{ before: full_name, after: birth_year_str } ->
        full_name
        |> Str.splitFirst " "
        |> Result.try \{ before: first_name, after: last_name } ->
            Str.toU16 birth_year_str
            |> Result.try \birth_year ->
                Ok { first_name, last_name, birth_year }

## This version is like `parseWithTry`, except it uses `Result.mapErr`
## to return more informative errors, just like the ones in `parseVerbose`.
parse_with_try_v2 = \line ->
    line
    |> Str.splitFirst " was born in "
    |> Result.mapErr \_ -> Err InvalidRecordFormat
    |> Result.try \{ before: full_name, after: birth_year_str } ->
        full_name
        |> Str.splitFirst " "
        |> Result.mapErr \_ -> Err InvalidNameFormat
        |> Result.try \{ before: first_name, after: last_name } ->
            Str.toU16 birth_year_str
            |> Result.mapErr \_ -> Err InvalidBirthYearFormat
            |> Result.try \birth_year ->
                Ok { first_name, last_name, birth_year }

## The `?` operator, called the "try operator", is
## [syntactic sugar](en.wikipedia.org/wiki/Syntactic_sugar) for `Result.try`.
## It makes the code much less nested and easier to read.
## The following function is equivalent to `parseWithTry`:
parse_with_try_op = \line ->
    { before: full_name, after: birth_year_str } = Str.splitFirst? line " was born in "
    { before: first_name, after: last_name } = Str.splitFirst? full_name " "
    birth_year = Str.toU16? birth_year_str
    Ok { first_name, last_name, birth_year }

## And lastly the following function is equivalent to `parseWithTryV2`.
## Note that the `?` operator has moved from `splitFirst` & `toU16` to `mapErr`:
parse_with_try_op_v2 = \line ->
    { before: full_name, after: birth_year_str } =
        line
        |> Str.splitFirst " was born in "
        |> Result.mapErr? \_ -> Err InvalidRecordFormat
    { before: first_name, after: last_name } =
        full_name
        |> Str.splitFirst " "
        |> Result.mapErr? \_ -> Err InvalidNameFormat
    birth_year =
        Str.toU16 birth_year_str
        |> Result.mapErr? \_ -> Err InvalidBirthYearFormat
    Ok { first_name, last_name, birth_year }

## This function parses a string using a given parser and returns a string to
## display to the user. Note how we can handle errors individually or in bulk.
parse = \line, parser ->
    when parser line is
        Ok { first_name, last_name, birth_year } ->
            """
            Name: $(last_name), $(first_name)
            Born:  $(birth_year |> Num.toStr)

            """

        Err InvalidNameFormat -> "What kind of a name is this?"
        Err InvalidBirthYearFormat -> "That birth year looks fishy."
        Err InvalidRecordFormat -> "Oh wow, that's a weird looking record!"
        _ -> "Something unexpected happened" # Err NotFound or Err InvalidNumStr

main! = \_ ->
    try Stdout.line! (parse "George Harrison was born in 1943" parse_verbose)
    try Stdout.line! (parse "John Lennon was born in 1940" parse_with_try)
    try Stdout.line! (parse "Paul McCartney was born in 1942" parse_with_try_v2)
    try Stdout.line! (parse "Ringo Starr was born in 1940" parse_with_try_op)
    try Stdout.line! (parse "Stuart Sutcliffe was born in 1940" parse_with_try_op_v2)

    Ok {}
