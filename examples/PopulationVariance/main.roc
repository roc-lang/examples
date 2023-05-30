app "population-variance"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br" }
    imports [
        pf.Stdout,
    ]
    provides [main] to pf

populationVariance : List (Frac a) -> Result (Frac a) [NotEnoughItems, Overflow]
populationVariance = \maybeEmptyPopulation ->

    variance = \population ->
        # σ² = ∑(X - µ)² / N
        # σ² = variance
        # X = each element
        # µ = mean
        # N = total elements of the population
        n = population |> List.len |> Num.toFrac

        mean =
            population
            |> List.walkTry 0.0 (\state, elem -> Num.addChecked state elem)
            |> Result.map (\x -> x / n)

        population
        |> List.walkTry
            0.0
            (\state, elem ->
                mean 
                |> Result.try (\m -> Num.subChecked elem m)
                |> Result.try (\x -> Num.mulChecked x x)
                |> Result.try (\x -> Num.addChecked x state))
        |> Result.map (\x -> x / n)

    # Check array lenght to prevent DivByZero
    if maybeEmptyPopulation |> List.isEmpty then
        Err NotEnoughItems
    else
        variance maybeEmptyPopulation

main =
    [4, 22, 99, 204, 18, 20]
    |> populationVariance
    |> Result.map Num.toStr
    |> Result.map (\v -> "σ² = \(v)")
    |> Result.mapErr
        (\reason ->
            when reason is
                NotEnoughItems -> "Not enough items"
                Overflow -> "An overflow occurred"
        )
    |> Result.withDefault ""
    |> Stdout.line

# expect (populationVariance []) == Err NotEnoughItems
# expect (populationVariance [0]) == Ok 0
# expect (populationVariance [100]) == Ok 0
# expect (populationVariance [4, 22, 99, 204, 18, 20]) == Ok 147.66666666666666
# expect (populationVariance [46, 69, 32, 60, 52, 41]) == Ok 5032.13888888889
