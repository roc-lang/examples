app [main!] {
	ascii: "https://github.com/ageron/roc-ascii/releases/download/v0.5.1/3mkSijmaYYGXbT6EvDAXyV4Y9YzYncztbWNDfRSr3z3f.tar.zst",
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.28.0/2yhxoR7cZPSYbyUzPWULFw8AA6QEcdsgFNRmzu7pZbst.tar.zst",
	roc: "nightly-2026-11-10-f7d1f19",
}

import cli.Stdout
import ascii.Ascii

# TODO unicode example

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
	Stdout.line!("\tdescending order: ${sorted_fruits_descending_str}")
}

ascii_list_to_str : List(Ascii.Ascii) -> Str
ascii_list_to_str = |ascii_list| Str.join_with(ascii_list.map(Ascii.to_str), ", ")
