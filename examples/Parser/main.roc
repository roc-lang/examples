app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.24.0/AEjfyaMFFbh8FJrkkHJy68riVNPr3Qp6c6PawWQjBwMH.tar.zst",
	parser: "https://github.com/lukewilliamboswell/roc-parser/releases/download/2.0.0/7CLzCK6qUz7zmj6nvBxMEFu11HPwQTnCovKiyWzDSLTW.tar.zst",
	roc: "nightly-2026-10-09-258ab27",
}

import cli.Stdout
import cli.Stderr
import cli.OsStr
import parser.Parser
import parser.Utf8

default_input_str = "ABRACADABRA"

main! : List(OsStr) => Try({}, [Exit(I32)])
main! = |args| {
	input_str = args.map(OsStr.display).get(1) ?? default_input_str

	match Utf8.parse_str(letter_parser.many(), input_str) {
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
letter_parser : Parser(Utf8.Bytes, Letter)
letter_parser =
	Parser.one_of([
		Utf8.codeunit('A').map(|_| A),
		Utf8.codeunit('B').map(|_| B),
		Utf8.codeunit('C').map(|_| C),
		Utf8.any_codeunit.map(|_| Other),
	])

# Test parsing a single letter B
expect {
	input = "B"
	parser = letter_parser
	result = Utf8.parse_str(parser, input)
	result == Ok(B)
}

# Test parsing a number of different letters
expect {
	input = "BCXA"
	parser = letter_parser.many()
	result = Utf8.parse_str(parser, input)
	result == Ok([B, C, Other, A])
}
