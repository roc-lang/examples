app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.0/F1JVZPYfWP71s8vk6tHcV1Qx1Ef6CZkwswGoCn8VHZmL.tar.zst",
	parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/1.0.2/FrnJ4RGDKpQyoDyESNoBwFNviY4ZGbMVLnUjW9tvSRjk.tar.zst",
	roc: "nightly-2026-08-31-86e69b4",
}

import cli.Stdout
import cli.Stderr
import cli.OsStr
import parser.Parser exposing [Parser, many, one_of, map]
import parser.String exposing [parse_str, codeunit, any_codeunit]

default_input_str = "ABRACADABRA"

main! : List(OsStr) => Try({}, [Exit(I32), ..])
main! = |args| {
	input_str = args.map(OsStr.display).get(1) ?? default_input_str

	match parse_str(many(letter_parser), input_str) {
		Ok(letters) => {
			count = count_letter_a(letters)
			msg = "I counted ${count} letter A's!"
			_ = Stdout.line!(msg)
			Ok({})
		}
		Err(err) => {
			_ = Stderr.line!("Parsing error: ${Str.inspect(err)}")
			Err(Exit(1))
		}
	}
}

Letter : [A, B, C, Other]

# Count the number of Letter A's
count_letter_a : List(Letter) -> Str
count_letter_a = |letters| {
	letters
		.count_if(|l| l == A)
		.to_str()
}

# Parser to convert utf8 input into Letter [tags](https://www.roc-lang.org/tutorial#tags)
letter_parser : Parser(List(U8), Letter)
letter_parser =
	one_of([
		codeunit('A').map(|_| A),
		codeunit('B').map(|_| B),
		codeunit('C').map(|_| C),
		any_codeunit.map(|_| Other),
	])

# Test parsing a single letter B
expect {
	input = "B"
	parser = letter_parser
	result = parse_str(parser, input)
	result == Ok(B)
}

# Test parsing a number of different letters
expect {
	input = "BCXA"
	parser = many(letter_parser)
	result = parse_str(parser, input)
	result == Ok([B, C, Other, A])
}
