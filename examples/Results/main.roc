app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/Lb8EgiejTUzbggO2HVVuPJFkwvvsfW6LojkLR20kTVE.tar.br",
}

import pf.Stdout
import pf.Task exposing [Task]

## This function parses strings like "{FirstName} {LastName} was born in {Year}"
## and if successful returns `Ok { firstName, lastName, birthYear}`.
## This is the most verbose version, we will do better below.
parseVerbose = \line ->
    when line |> Str.splitFirst " was born in " is
        Ok { before: fullName, after: birthYearStr } ->
            when fullName |> Str.splitFirst " " is
                Ok { before: firstName, after: lastName } ->
                    when Str.toU16 birthYearStr is
                        Ok birthYear ->
                            Ok { firstName, lastName, birthYear }

                        Err _ -> Err InvalidBirthYearFormat

                _ -> Err InvalidNameFormat

        _ -> Err InvalidRecordFormat

## Here's a very slightly shorter version using `Result.try` to chain multiple
## functions that each could return an error. It's a bit nicer, don't you think?
## Note: this version returns "raw" errors (`Err NotFound` or `Err InvalidNumStr`).
parseWithTry = \line ->
    line
    |> Str.splitFirst " was born in "
    |> Result.try \{ before: fullName, after: birthYearStr } ->
        fullName
        |> Str.splitFirst " "
        |> Result.try \{ before: firstName, after: lastName } ->
            Str.toU16 birthYearStr
            |> Result.try \birthYear ->
                Ok { firstName, lastName, birthYear }

## This function is like `parseWithTry`, except it uses `Result.mapErr`
## to return more informative errors, just like the ones in `parseVerbose`.
parseWithTryV2 = \line ->
    line
    |> Str.splitFirst " was born in "
    |> Result.mapErr \_ -> Err InvalidRecordFormat
    |> Result.try \{ before: fullName, after: birthYearStr } ->
        fullName
        |> Str.splitFirst " "
        |> Result.mapErr \_ -> Err InvalidNameFormat
        |> Result.try \{ before: firstName, after: lastName } ->
            Str.toU16 birthYearStr
            |> Result.mapErr \_ -> Err InvalidBirthYearFormat
            |> Result.try \birthYear ->
                Ok { firstName, lastName, birthYear }

## A new operator `?` (the "try" operator) will soon be added to the language:
## it will offer a much cleaner, less nested syntax for such `Result.try` chaining.
## See https://github.com/roc-lang/roc/issues/6828 for more details.
## The following function will be equivalent to `parseWithTry`:
# parseWithTryOp = \line ->
#     { before: fullName, after: birthYearStr } = Str.splitFirst? line " was born in "
#     { before: firstName, after: lastName } = Str.splitFirst? fullName " "
#     birthYear = Str.toU16? birthYearStr
#     Ok { firstName, lastName, birthYear }

## And lastly the following function will be equivalent to `parseWithTryV2`.
## Note that the `?` operator has moved from `splitFirst` & `toU16` to `mapErr`:
# parseWithTryOpV2 = \line ->
#     { before: fullName, after: birthYearStr } =
#         line
#         |> Str.splitFirst " was born in "
#         |> Result.mapErr? \_ -> Err InvalidRecordFormat
#     { before: firstName, after: lastName } =
#         fullName
#         |> Str.splitFirst " "
#         |> Result.mapErr? \_ -> Err InvalidNameFormat
#     birthYear = 
#         Str.toU16 birthYearStr
#         |> Result.mapErr? \_ -> Err InvalidBirthYearFormat
#     Ok { firstName, lastName, birthYear }

## This function parses a string using a given parser and returns a string to
## display to the user. Note how we can handle errors individually or in bulk.
parse = \line, parser ->
    when parser line is
        Ok { firstName, lastName, birthYear } ->
            """
            Name: $(lastName), $(firstName)
            Born:  $(birthYear |> Num.toStr)

            """

        Err InvalidNameFormat -> "What kind of a name is this?"
        Err InvalidBirthYearFormat -> "That birth year looks fishy."
        Err InvalidRecordFormat -> "Oh wow, that's a weird looking record!"
        _  -> "Something unexpected happened" # Err NotFound or Err InvalidNumStr


main =
    "George Harrison was born in 1943" |> parse parseVerbose |> Stdout.line!
    "John Lennon was born in 1940" |> parse parseWithTry |> Stdout.line!
    "Paul McCartney was born in 1942" |> parse parseWithTryV2 |> Stdout.line!
# "Ringo Starr was born in 1940" |> parse parseWithTryOp |> Stdout.line!
# "Stuart Sutcliffe was born in 1940" |> parse parseWithTryOpV2 |> Stdout.line!
