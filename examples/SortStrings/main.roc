app [main!] {
	ascii: "https://github.com/ageron/roc-ascii/releases/download/v0.5.1/3mkSijmaYYGXbT6EvDAXyV4Y9YzYncztbWNDfRSr3z3f.tar.zst",
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.28.0/2yhxoR7cZPSYbyUzPWULFw8AA6QEcdsgFNRmzu7pZbst.tar.zst",
	roc: "nightly-2026-11-12-ce942d6",
	unicode: "https://github.com/roc-lang/unicode/releases/download/4.3.2/3gvgiWm6BShjHKbNV2zRH6fhC5ZvScZgWF7AnVDWHSdd.tar.zst",
}

import cli.Stdout
import ascii.Ascii
import unicode.Case

main! = |_args| {
	fruits = [
		"banana",
		"apple",
		"cherry",
	]

	# If you copy this code, make sure that your strings are valid ASCII.
	fruits_ascii = fruits.map_try(Ascii.from_str)?

	sorted_fruits_ascending = Ascii.sort_asc(fruits_ascii)
	sorted_fruits_ascending_str = ascii_list_to_str(sorted_fruits_ascending)

	expect sorted_fruits_ascending_str == "apple, banana, cherry"

	sorted_fruits_descending = Ascii.sort_desc(fruits_ascii)
	sorted_fruits_descending_str = ascii_list_to_str(sorted_fruits_descending)

	expect sorted_fruits_descending_str == "cherry, banana, apple"

	Stdout.line!("\nSorted fruits:")?
	Stdout.line!("\tascending order: ${sorted_fruits_ascending_str}")?
	Stdout.line!("\tdescending order: ${sorted_fruits_descending_str}")?

	# Unicode, sorting ignoring case. These strings are not ASCII only.
	words = ["banana", "Cherry", "apple", "Straße"]

	# Strings are compared by code point, so uppercase letters come before lowercase ones.
	sorted_words_code_point = words.sort_with(compare_str)

	expect sorted_words_code_point == ["Cherry", "Straße", "apple", "banana"]

	sorted_words = sort_ignoring_case(words)?

	expect sorted_words == ["apple", "banana", "Cherry", "Straße"]

	Stdout.line!("\nSorted words:")?
	Stdout.line!("\tby code point: ${Str.inspect(sorted_words_code_point)}")?
	Stdout.line!("\tignoring case: ${Str.inspect(sorted_words)}")
}

# Sorts by the case folded strings, full case folding also handles things like "ß" -> "ss".
sort_ignoring_case = |strs| {
	limits = Case.limits(1_000, 1_000, 3_000, 3_000, 1_000)
	keyed = strs.map_try(
		|str| {
			folded = Case.fold(str, Case.full, limits)?
			Ok((Case.result_text(folded), str))
		},
	)?

	Ok(
		keyed
			.sort_with(|(a, _), (b, _)| compare_str(a, b))
			.map(|(_, str)| str),
	)
}

# UTF-8 bytes are ordered like code points, so comparing bytes sorts by code point.
compare_str = |a, b| {
	bytes_a = a.to_utf8()
	bytes_b = b.to_utf8()
	first_difference = bytes_a.map2(bytes_b, |x, y| x.order_relative_to(y)).find_first(|order| order != Same)

	match first_difference {
		Ok(order) => order
		Err(NotFound) => bytes_a.len().order_relative_to(bytes_b.len())
	}
}

ascii_list_to_str : List(Ascii.Ascii) -> Str
ascii_list_to_str = |ascii_list| Str.join_with(ascii_list.map(Ascii.to_str), ", ")
