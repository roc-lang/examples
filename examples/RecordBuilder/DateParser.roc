module [
    ParserGroup,
    ParserErr,
    parse_with,
    chain_parsers,
    build_segment_parser,
]

ParserErr : [InvalidNumStr, OutOfSegments]

ParserGroup a := List Str -> Result (a, List Str) ParserErr

parse_with : (Str -> Result a ParserErr) -> ParserGroup a
parse_with = \parser ->
    @ParserGroup \segments ->
        when segments is
            [] -> Err OutOfSegments
            [first, .. as rest] ->
                parsed = parser? first
                Ok (parsed, rest)

chain_parsers : ParserGroup a, ParserGroup b, (a, b -> c) -> ParserGroup c
chain_parsers = \@ParserGroup first, @ParserGroup second, combiner ->
    @ParserGroup \segments ->
        (a, after_first) = first? segments
        (b, after_second) = second? after_first

        Ok (combiner a b, after_second)

build_segment_parser : ParserGroup a -> (Str -> Result a ParserErr)
build_segment_parser = \@ParserGroup parser_group ->
    \text ->
        segments = Str.splitOn text "-"
        (date, _remaining) = parser_group? segments

        Ok date

expect
    date_parser =
        { chain_parsers <-
            month: parse_with Ok,
            day: parse_with Str.toU64,
            year: parse_with Str.toU64,
        }
        |> build_segment_parser

    date = date_parser "Mar-10-2015"

    date == Ok { month: "Mar", day: 10, year: 2015 }
