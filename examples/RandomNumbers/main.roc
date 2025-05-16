app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
    rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.5.0/yDUoWipuyNeJ-euaij4w_ozQCWtxCsywj68H0PlJAdE.tar.br",
}

import cli.Stdout
import cli.Arg exposing [Arg]
import rand.Random

main! : List Arg => Result {} _
main! = |_args|

    # Print a list of 10 random numbers.
    numbers_str =
        random_numbers
        |> List.map(Num.to_str)
        |> Str.join_with("\n")

    Stdout.line!(numbers_str)

# Generate a list of random numbers using the seed `1234`.
# This is NOT cryptograhpically secure!
random_numbers : List U32
random_numbers =
    { value: numbers } = Random.step(Random.seed(1234), numbers_generator)

    numbers

# A generator that will produce a list of 10 random numbers in the range 25-75.
# This includes the boundaries, so the numbers can be 25 or 75.
# This is NOT cryptograhpically secure!
numbers_generator : Random.Generator (List U32)
numbers_generator =
    Random.list(Random.bounded_u32(25, 75), 10)

expect
    actual = random_numbers
    actual == [52, 34, 26, 69, 34, 35, 51, 74, 70, 39]
