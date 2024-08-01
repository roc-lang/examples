app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/Lb8EgiejTUzbggO2HVVuPJFkwvvsfW6LojkLR20kTVE.tar.br",
}

import pf.Stdout
import pf.Task exposing [Task]

# This function parses a string formatted like "{FirstName} {LastName} was born in {Year}"
# This is the most verbose version. It's a bit too nested, we will do better below.
parsePersonVerbose = \line ->
    when line |> Str.split " was born in " is
        [fullName, birthYearStr] ->
            when fullName |> Str.split " " is
                [firstName, lastName] ->
                    when Str.toU16 birthYearStr is
                        Ok birthYear ->
                            Ok { firstName, lastName, birthYear }

                        Err _ -> Err (ParsingErr InvalidBirthYearFormat)

                _ -> Err (ParsingErr InvalidNameFormat)

        _ -> Err (ParsingErr InvalidRecordFormat)

## This is a utility function, used below to convert [a, b] to Result (a, b)
toPair = \listWithTwoItems ->
    when listWithTwoItems is
        [a, b] -> Ok (a, b)
        _ -> Err NotAPair

## This is a much nicer parser, using the backpassing syntax.
## See https://github.com/roc-lang/roc/blob/main/roc-for-elm-programmers.md#backpassing
## This version returns "raw" errors (i.e., `Err NotAPair` or `Err InvalidNumStr`).
parsePersonBackpassing = \line ->
    (fullName, birthYearStr) <- line |> Str.split " was born in " |> toPair |> Result.try
    (firstName, lastName) <- fullName |> Str.split " " |> toPair |> Result.try
    birthYear <- Str.toU16 birthYearStr |> Result.try
    Ok { firstName, lastName, birthYear }

## This function is the same as the previous one, except it uses `Result.mapErr` to
## return more informative errors, just like `parsePersonVerbose`.
parsePersonBackpassingV2 = \line ->
    (fullName, birthYearStr) <- line
        |> Str.split " was born in "
        |> toPair
        |> Result.mapErr (\_ -> Err (ParsingErr InvalidRecordFormat))
        |> Result.try
    (firstName, lastName) <- fullName
        |> Str.split " "
        |> toPair
        |> Result.mapErr (\_ -> Err (ParsingErr InvalidNameFormat))
        |> Result.try
    birthYear <- Str.toU16 birthYearStr
        |> Result.mapErr (\_ -> Err (ParsingErr InvalidBirthYearFormat))
        |> Result.try
    Ok { firstName, lastName, birthYear }

## A new operator ? (the "try" operator) will replace backpassing.
## See https://github.com/roc-lang/roc/issues/6828 for more details.
## It will look something like this:
# parsePersonTryOperator = \line ->
#     (fullName, birthYearStr) = line |> Str.split " was born in " |> toPair?
#     (firstName, lastName) = fullName |> Str.split " " |> toPair?
#     birthYear = Str.toU16? birthYearStr
#     Ok { firstName, lastName, birthYear }

## This function also uses the ? operator, but this time it uses `Result.mapErr`
## to return more informative errors, much like in `parsePersonBackpassingV2`.
## Note that the `?` operator has moved from `toPair` and `Str.toU16` to `mapErr`:
# parsePersonTryOperatorV2 = \line ->
#     (fullName, birthYearStr) =
#         line
#         |> Str.split " was born in "
#         |> toPair
#         |> Result.mapErr? (\_ -> Err (ParsingErr InvalidRecordFormat))
#     (firstName, lastName) =
#         fullName
#         |> Str.split " "
#         |> toPair
#         |> Result.mapErr? (\_ -> Err (ParsingErr InvalidNameFormat))
#     birthYear =
#         Str.toU16 birthYearStr
#         |> Result.mapErr? (\_ -> Err (ParsingErr InvalidBirthYearFormat))
#     Ok { firstName, lastName, birthYear }

## This function parses a line using a given parser, and gets the string to display
parseWith = \line, parser ->
    when parser line is
        Ok person ->
            """
            Name: $(person.lastName), $(person.firstName)
            Born:  $(person.birthYear |> Num.toStr)
            """

        Err (ParsingErr InvalidNameFormat) -> "What kind of a name is this?"
        Err (ParsingErr InvalidBirthYearFormat) -> "Hey! That's not a birth year!"
        Err (ParsingErr InvalidRecordFormat) -> "This record is unreadable."
        _ -> "This record is just wrong."
# As you can see, you can handle errors individually, or in bulk

main =
    "George Harrison was born in 1943" |> parseWith parsePersonVerbose |> Stdout.line!
    "John Lennon was born in 1940" |> parseWith parsePersonBackpassing |> Stdout.line!
    "Paul McCartney was born in 1942" |> parseWith parsePersonBackpassingV2 |> Stdout.line!
# "Ringo Starr was born in 1940" |> parseWith parsePersonTryOperator |> Stdout.line!
# "Stuart Sutcliffe was born in 1940" |> parseWith parsePersonTryOperatorV2 |> Stdout.line!
