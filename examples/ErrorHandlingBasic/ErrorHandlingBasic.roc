module []

Person : { first_name : Str, last_name : Str, birth_year : U16 }

parse_person : Str -> Result Person [InvalidSentenceFormat Str, InvalidNameFormat Str, InvalidBirthYearFormat Str]
parse_person = |line|
    { before: full_name, after: birth_year_str } =
        # The NotFound error is not very informative, so we discard it with `_` and provide our own.
        Str.split_first(line, " was born in ") ? |_| InvalidSentenceFormat(line)

    { before: first_name, after: last_name } =
        Str.split_first(full_name, " ") ? |_| InvalidNameFormat(full_name)

    birth_year = Str.to_u16(birth_year_str) ? |_| InvalidBirthYearFormat(birth_year_str)

    Ok({ first_name, last_name, birth_year })

expect parse_person("George Harrison was born in 1943") == Ok({ first_name: "George", last_name: "Harrison", birth_year: 1943 })
