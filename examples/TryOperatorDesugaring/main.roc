main! : List(Str) => Try({}, _)
main! = |_args| {
	person1 = parse_name_and_year("Alice was born in 1990")?
	person2 = parse_name_and_year_try("Bob was born in 1985")?

	msg = if person1.birth_year < person2.birth_year {
		"${person1.name} is older than ${person2.name}"
	} else {
		"${person2.name} is older than ${person1.name}"
	}

	echo!(msg)

	Ok({})
}

### start snippet question
parse_name_and_year : Str -> Try({ name : Str, birth_year : U16 }, _)
parse_name_and_year = |str| {
	words = str.split_on(" ")

	name = words.first()?

	birth_year_str = List.last(words)?
	# TODO: commented out line causes this panic:
	# Interpreter error: error.InvalidMethodReceiver
	# Execution error: error.InterpreterFailed
	# birth_year_str = words.last()?
	#
	birth_year = U16.from_str(birth_year_str)?

	Ok({ name, birth_year })
}
### end snippet question

### start snippet desugared
parse_name_and_year_try = |str| {
	words = str.split_on(" ")
	name = match words.first() {
		Err(err) => {
			return Err(err)
		}
		Ok(value) => value
	}

	# TODO: same as above
	birth_year_str = match List.last(words) {
		Err(err) => {
			return Err(err)
		}
		Ok(value) => value
	}

	birth_year = match U16.from_str(birth_year_str) {
		Err(err) => {
			return Err(err)
		}
		Ok(value) => value
	}

	Ok({ name, birth_year })
}
### end snippet desugared

expect parse_name_and_year("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
expect parse_name_and_year_try("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
