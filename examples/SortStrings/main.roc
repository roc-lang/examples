app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br",
    ascii: "https://github.com/Hasnep/roc-ascii/releases/download/v0.3.1/1PCTQ0tzSijxfhxDg1k_yPtfOXiAk3j283b8EWGusVc.tar.br",
}

import cli.Stdout
import cli.Arg exposing [Arg]
import ascii.Ascii

# TODO unicode example

main! : List Arg => Result {} _
main! = |_args|
    fruits = [
        "banana",
        "apple",
        "cherry",
    ]

    # If you copy this code, make sure that your strings are valid ASCII.
    fruits_ascii = List.map_try(fruits, Ascii.from_str) ? FruitListContainsInvalidAscii

    sorted_fruits_ascending = Ascii.sort_asc(fruits_ascii)

    sorted_fruits_ascending_str =
        ascii_list_to_str(sorted_fruits_ascending)

    expect sorted_fruits_ascending_str == "apple, banana, cherry"

    sorted_fruits_descending = Ascii.sort_desc(fruits_ascii)

    sorted_fruits_descending_str =
        ascii_list_to_str(sorted_fruits_descending)

    expect sorted_fruits_descending_str == "cherry, banana, apple"

    Stdout.line!("\nSorted fruits:")?
    Stdout.line!("\tascending order: ${sorted_fruits_ascending_str}")?
    Stdout.line!("\tdescending order: ${sorted_fruits_descending_str}")

ascii_list_to_str : List Ascii.Ascii -> Str
ascii_list_to_str = |ascii_list|
    ascii_list
    |> List.map(Ascii.to_str)
    |> Str.join_with(", ")
