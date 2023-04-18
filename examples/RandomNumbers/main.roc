app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br",
        rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.0.1/x_XwrgehcQI4KukXligrAkWTavqDAdE5jGamURpaX-M.tar.br",
    }
    imports [
        pf.Stdout,
        rand.Random,
    ]
    provides [main] to pf

# Print a list of 10 random numbers in the range 25-75 inclusive.
main =

    # Initialise "randomness"
    initialSeed = Random.seed16 42

    # Create a generator for values from 25-75 (inclusive)
    u16 = Random.u16 25 75

    # Create a list of random numbers
    result =
        List.range { start: At 0, end: Before 10 }
        |> List.walk { seed: initialSeed, numbers: [] } \state, _ ->

            random = u16 state.seed
            seed = random.state
            numbers = List.append state.numbers random.value

            { seed, numbers }

    # Format as a string
    numbersListStr =
        result.numbers
        |> List.map Num.toStr
        |> Str.joinWith ","

    Stdout.line "Random numbers are: \(numbersListStr)"
