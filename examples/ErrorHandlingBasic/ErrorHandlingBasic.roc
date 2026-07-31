Person : { first_name : Str, last_name : Str, birth_year : U16 }

parse_person : Str -> Try(Person, [InvalidSentenceFormat(Str), InvalidNameFormat(Str), InvalidBirthYearFormat(Str), ..])
parse_person = |line| {
	{ before: full_name, after: birth_year_str } =
	# The NotFound error is not very informative, so we discard it with `_` and provide our own.
		line.split_first(" was born in ") ? |_| InvalidSentenceFormat(line)

	{ before: first_name, after: last_name } =
		full_name.split_first(" ") ? |_| InvalidNameFormat(full_name)

	birth_year = U16.from_str(birth_year_str) ? |_| InvalidBirthYearFormat(birth_year_str)

	Ok({ first_name, last_name, birth_year })
}

expect parse_person("George Harrison was born in 1943") == Ok({ first_name: "George", last_name: "Harrison", birth_year: 1943 })
expect parse_person("John Lennon was born in 1940") == Ok({ first_name: "John", last_name: "Lennon", birth_year: 1940 })
expect parse_person("Paul McCartney was born in 1942") == Ok({ first_name: "Paul", last_name: "McCartney", birth_year: 1942 })
expect parse_person("Ringo Starr was born in MCMXL") == Err(InvalidBirthYearFormat("MCMXL"))

main! = |_| Ok({})
