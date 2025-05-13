app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import cli.Arg exposing [Arg]

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
safe_variance : List (Frac a) -> Result (Frac a) [EmptyInputList, Overflow]
safe_variance = |maybe_empty_list|

    # Check length to prevent division by zero
    when List.len(maybe_empty_list) is
        0 -> Err(EmptyInputList)
        _ ->
            non_empty_list = maybe_empty_list

            n = non_empty_list |> List.len |> Num.to_frac

            mean =
                non_empty_list # sum of all elements:
                |> List.walk_try(0.0, |state, elem| Num.add_checked(state, elem))
                |> Result.map_ok(|x| x / n)

            non_empty_list
            |> List.walk_try(
                0.0,
                |state, elem|
                    mean
                    |> Result.try(|m| Num.sub_checked(elem, m)) # X - µ
                    |> Result.try(|y| Num.mul_checked(y, y)) # ²
                    |> Result.try(|z| Num.add_checked(z, state)), # ∑
            )
            |> Result.map_ok(|x| x / n)

main! : List Arg => Result {} _
main! = |_args|

    variance_result =
        [46, 69, 32, 60, 52, 41]
        |> safe_variance
        |> Result.map_ok(Num.to_str)
        |> Result.map_ok(|v| "σ² = ${v}")

    output_str =
        when variance_result is
            Ok(str) -> str
            Err(EmptyInputList) -> "Error: EmptyInputList: I can't calculate the variance over an empty list."
            Err(Overflow) -> "Error: Overflow: When calculating the variance, a number got too large to store in the available memory for the type."

    Stdout.line!(output_str)

expect safe_variance([]) == Err(EmptyInputList)
expect safe_variance([0]) == Ok(0)
expect safe_variance([100]) == Ok(0)
expect safe_variance([4, 22, 99, 204, 18, 20]) == Ok(5032.138888888888888888)
expect safe_variance([46, 69, 32, 60, 52, 41]) == Ok(147.666666666666666666)
