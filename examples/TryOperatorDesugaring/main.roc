main! = |_| {
	echo!("${Str.inspect(parse_name_and_year("Alice was born in 1990"))}\n")
	echo!("${Str.inspect(parse_name_and_year_try("Alice was born in 1990"))}\n")
	Ok({})
}

### start snippet question
parse_name_and_year : Str -> Try({ name : Str, birth_year : U16 }, [BadFormat, BadNumStr, ..])
parse_name_and_year = |str| {
	{ before: name, after: birth_year_str } = str.split_first(" was born in ") ? |_| BadFormat
	birth_year = U16.from_str(birth_year_str)?
	Ok({ name, birth_year })
}

### end snippet question

### start snippet desugared
parse_name_and_year_try : Str -> Try({ name : Str, birth_year : U16 }, [BadFormat, BadNumStr, ..])
parse_name_and_year_try = |str| {
	match str.split_first(" was born in ") {
		Err(_) => Err(BadFormat)
		Ok({ before: name, after: birth_year_str }) => {
			match U16.from_str(birth_year_str) {
				Err(err2) => Err(err2)
				Ok(birth_year) => Ok({ name, birth_year })
			}
		}
	}
}

### end snippet desugared

expect parse_name_and_year("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
expect parse_name_and_year_try("Alice was born in 1990") == Ok({ name: "Alice", birth_year: 1990 })
