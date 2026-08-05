# see README.md for explanation of code
ParserErr : [BadNumStr, OutOfSegments]

Parser(a) : List(Str) -> Try((a, List(Str)), ParserErr)

DateParser :: {}.{
	map2 : Parser(a), Parser(b), (a, b -> c) -> Parser(c)
	map2 = |first, second, combiner|
		|segments| {
			(a, after_first) = first(segments)?
			(b, after_second) = second(after_first)?

			Ok((combiner(a, b), after_second))
		}

	parse_with : (Str -> Try(a, ParserErr)) -> Parser(a)
	parse_with = |parser|
		|segments|
			match segments {
				[] => Err(OutOfSegments)
				[first, .. as rest] => {
					parsed = parser(first)?
					Ok((parsed, rest))
				}
			}

	parse_str : Parser(Str)
	parse_str = DateParser.parse_with(|s| Ok(s))

	parse : Parser(a), Str -> Try(a, ParserErr)
	parse = |parser, text| {
		segments = Str.split_on(text, "-")
		(date, _remaining) = parser(segments)?

		Ok(date)
	}
}

expect {
	date_parser = {
		month: DateParser.parse_str,
		day: DateParser.parse_with(U64.from_str),
		year: DateParser.parse_with(U64.from_str),
	}.DateParser

	DateParser.parse(date_parser, "Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })
}

expect {
	date_parser =
		DateParser.map2(
			DateParser.parse_str,
			DateParser.map2(
				DateParser.parse_with(U64.from_str),
				DateParser.parse_with(U64.from_str),
				|day, year| (day, year),
			),
			|month, (day, year)| { month, day, year },
		)

	DateParser.parse(date_parser, "Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })
}
