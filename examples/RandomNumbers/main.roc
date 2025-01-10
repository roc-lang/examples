app [main!] {
    cli: platform "../../../basic-cli/platform/main.roc",
    rand: "../../../roc-random/package/main.roc",
}

import cli.Stdout
import rand.Random

main! = \_args ->

    # Print a list of 10 random numbers in the range 25-75 inclusive.
    numbers_str =
        random_numbers
        |> List.map(Num.to_str)
        |> Str.join_with("\n")

    Stdout.line!(numbers_str)

# Generate a list random numbers using the seed `1234`.
# This is NOT cryptograhpically secure!
random_numbers : List U32
random_numbers =
    { value: numbers } = Random.step(Random.seed(1234), numbers_generator)

    numbers

# A generator that will produce a list of 10 random numbers in the range 25-75 inclusive.
# This is NOT cryptograhpically secure!
numbers_generator : Random.Generator (List U32)
numbers_generator =
    Random.list(Random.bounded_u32(25, 75), 10)

expect
    actual = random_numbers
    actual == [52, 34, 26, 69, 34, 35, 51, 74, 70, 39]
