module [
    ParserGroup,
    ParserErr,
    parseWith,
    chainParsers,
    buildSegmentParser,
]

ParserErr : [InvalidNumStr, OutOfSegments]

ParserGroup a := List Str -> Result (a, List Str) ParserErr

parseWith : (Str -> Result a ParserErr) -> ParserGroup a
parseWith = \parser ->
    @ParserGroup \segments ->
        when segments is
            [] -> Err OutOfSegments
            [first, .. as rest] ->
                parsed = parser? first
                Ok (parsed, rest)

chainParsers : ParserGroup a, ParserGroup b, (a, b -> c) -> ParserGroup c
chainParsers = \@ParserGroup first, @ParserGroup second, combiner ->
    @ParserGroup \segments ->
        (a, afterFirst) = first? segments
        (b, afterSecond) = second? afterFirst

        Ok (combiner a b, afterSecond)

buildSegmentParser : ParserGroup a -> (Str -> Result a ParserErr)
buildSegmentParser = \@ParserGroup parserGroup ->
    \text ->
        segments = Str.splitOn text "-"
        (date, _remaining) = parserGroup? segments

        Ok date

expect
    dateParser =
        { chainParsers <-
            month: parseWith Ok,
            day: parseWith Str.toU64,
            year: parseWith Str.toU64,
        }
        |> buildSegmentParser

    date = dateParser "Mar-10-2015"

    date == Ok { month: "Mar", day: 10, year: 2015 }
