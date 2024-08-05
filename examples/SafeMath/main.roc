app [main] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.13.0/nW9yMRtZuCYf1Oa9vbE5XoirMwzLbtoSgv7NGhUlqYA.tar.br" }

import cli.Stdout

## Safely calculates the variance of a population.
##
## variance formula: σ² = ∑(X - µ)² / N
##
## σ² = variance
## X = each element
## µ = mean of elements
## N = length of list
##
## Performance note: safe or checked math prevents crashes but also runs slower.
##
safeVariance : List (Frac a) -> Result (Frac a) [EmptyInputList, Overflow]
safeVariance = \maybeEmptyList ->

    # Check length to prevent DivByZero
    when List.len maybeEmptyList is
        0 -> Err EmptyInputList
        _ ->
            nonEmptyList = maybeEmptyList

            n = nonEmptyList |> List.len |> Num.toFrac

            mean =
                nonEmptyList # sum of all elements:
                |> List.walkTry 0.0 (\state, elem -> Num.addChecked state elem)
                |> Result.map (\x -> x / n)

            nonEmptyList
            |> List.walkTry
                0.0
                (\state, elem ->
                    mean
                    |> Result.try (\m -> Num.subChecked elem m) # X - µ
                    |> Result.try (\y -> Num.mulChecked y y) # ²
                    |> Result.try (\z -> Num.addChecked z state)) # ∑
            |> Result.map (\x -> x / n)

main =

    varianceResult =
        [46, 69, 32, 60, 52, 41]
        |> safeVariance
        |> Result.map Num.toStr
        |> Result.map (\v -> "σ² = $(v)")

    outputStr =
        when varianceResult is
            Ok str -> str
            Err EmptyInputList -> "Error: EmptyInputList: I can't calculate the variance over an empty list."
            Err Overflow -> "Error: Overflow: When calculating the variance, a number got too large to store in the available memory for the type."

    Stdout.line outputStr

expect (safeVariance []) == Err EmptyInputList
expect (safeVariance [0]) == Ok 0
expect (safeVariance [100]) == Ok 0
expect (safeVariance [4, 22, 99, 204, 18, 20]) == Ok 5032.138888888888888888
expect (safeVariance [46, 69, 32, 60, 52, 41]) == Ok 147.666666666666666666
