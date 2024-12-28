app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
    rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.4.0/Ai2KfHOqOYXZmwdHX3g3ytbOUjTmZQmy0G2R9NuPBP0.tar.br",
}

import pf.Stdout
import rand.Random

main! = \_ ->

    # Print a list of 10 random numbers in the range 25-75 inclusive.
    numbers_str =
        randomNumbers
        |> List.map Num.toStr
        |> Str.joinWith "\n"

    Stdout.line! numbers_str

# Generate a list random numbers using the seed `1234`.
randomNumbers : List U32
randomNumbers =
    { value: numbers } = Random.step (Random.seed 1234) numbersGenerator

    numbers

# A generator that will produce a list of 10 random numbers in the range 25-75 inclusive.
numbersGenerator : Random.Generator (List U32)
numbersGenerator =
    Random.list (Random.boundedU32 25 75) 10

expect
    actual = randomNumbers
    actual == [52, 34, 26, 69, 34, 35, 51, 74, 70, 39]
