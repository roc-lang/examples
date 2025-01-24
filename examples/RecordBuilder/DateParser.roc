module [
    ParserGroup,
    ParserErr,
    parse_with,
    chain_parsers,
    build_segment_parser,
]

# see README.md for explanation of code
ParserErr : [InvalidNumStr, OutOfSegments]

ParserGroup a := List Str -> Result (a, List Str) ParserErr

parse_with : (Str -> Result a ParserErr) -> ParserGroup a
parse_with = |parser|
    @ParserGroup(
        |segments|
            when segments is
                [] -> Err(OutOfSegments)
                [first, .. as rest] ->
                    parsed = parser(first)?
                    Ok((parsed, rest)),
    )

chain_parsers : ParserGroup a, ParserGroup b, (a, b -> c) -> ParserGroup c
chain_parsers = |@ParserGroup(first), @ParserGroup(second), combiner|
    @ParserGroup(
        |segments|
            (a, after_first) = first(segments)?
            (b, after_second) = second(after_first)?

            Ok((combiner(a, b), after_second)),
    )

build_segment_parser : ParserGroup a -> (Str -> Result a ParserErr)
build_segment_parser = |@ParserGroup(parser_group)|
    |text|
        segments = Str.split_on(text, "-")
        (date, _remaining) = parser_group(segments)?

        Ok(date)

expect
    date_parser =
        { chain_parsers <-
            month: parse_with(Ok),
            day: parse_with(Str.to_u64),
            year: parse_with(Str.to_u64),
        }
        |> build_segment_parser

    date_parser("Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })

expect
    date_parser =
        build_segment_parser(
            chain_parsers(
                parse_with(Ok),
                chain_parsers(
                    parse_with(Str.to_u64),
                    parse_with(Str.to_u64),
                    |day, year| (day, year),
                ),
                |month, (day, year)| { month, day, year },
            ),
        )

    date_parser("Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })
