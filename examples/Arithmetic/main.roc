app "arithmetic"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br" }
    imports [
        pf.Stdout,
    ]
    provides [main] to pf

# The possible operations we can execute
Operation : [Sum, Subtract, Multiply, DivTrunc, Remainder, PowInt]

# A representation of the results of operations
OperationResult a : {
    rep : Str,
    outcome : Result [Computed (Int a), UnsafeComputed (Int a)] [Overflow, DivByZero],
}

tryApplyOperation : Operation, Int a, Int a -> OperationResult a
tryApplyOperation = \operation, a, b ->
    rep =
        aStr = a |> Num.toStr
        bStr = b |> Num.toStr
        symbol =
            when operation is
                Sum -> "+"
                Subtract -> "-"
                Multiply -> "x"
                DivTrunc -> "//"
                Remainder -> "%"
                PowInt -> "^"

        "\(aStr) \(symbol) \(bStr)"

    outcome =
        when operation is
            Sum -> Num.addChecked a b |> Result.map Computed
            Subtract -> Num.subChecked a b |> Result.map Computed
            Multiply -> Num.mulChecked a b |> Result.map Computed
            DivTrunc -> Num.divTruncChecked a b |> Result.map Computed
            Remainder -> Num.remChecked a b |> Result.map Computed
            PowInt -> Ok (Num.powInt a b) |> Result.map UnsafeComputed

    { rep, outcome }

tryApplyAllOperations : (Int a, Int a) -> List (OperationResult a)
tryApplyAllOperations = \(a, b) ->
    [Sum, Subtract, Multiply, DivTrunc, Remainder, PowInt]
    |> List.map (\operation -> tryApplyOperation operation a b)

formatOperationResult : OperationResult a -> Str
formatOperationResult = \operationResult ->
    when operationResult.outcome is
        Ok (Computed result) ->
            resultStr = Num.toStr result
            "✅ \(operationResult.rep) = \(resultStr)"

        Ok (UnsafeComputed result) ->
            resultStr = Num.toStr result
            "⚠ \(operationResult.rep) = \(resultStr) (an overflow might have happened)"

        Err Overflow ->
            "❌ \(operationResult.rep) would result in an overflow"

        Err DivByZero ->
            "❌ \(operationResult.rep) would result in a division by zero"

main =

    format = \item ->
        when item is
            Results results ->
                results |> List.map formatOperationResult |> Str.joinWith "\n"

            Separator ->
                Str.repeat "-" 50

    toPrint =
        [(0, 0), (2, 10), (-5, 40)]
        |> List.map tryApplyAllOperations
        |> List.map Results
        |> List.intersperse Separator
        |> List.map format
        |> Str.joinWith "\n"

    Stdout.line toPrint

## Some tests

expect tryApplyOperation Sum 0 0 == { rep: "0 + 0", outcome: Ok (Computed 0) }
expect tryApplyOperation Sum 2 4 == { rep: "2 + 4", outcome: Ok (Computed 6) }
expect tryApplyOperation Sum -2 2 == { rep: "-2 + 2", outcome: Ok (Computed 0) }
expect tryApplyOperation Sum Num.maxI64 1 == { rep: "9223372036854775807 + 1", outcome: Err Overflow }

expect tryApplyOperation Subtract 0 0 == { rep: "0 - 0", outcome: Ok (Computed 0) }
expect tryApplyOperation Subtract 5 5 == { rep: "5 - 5", outcome: Ok (Computed 0) }
expect tryApplyOperation Subtract 5 2 == { rep: "5 - 2", outcome: Ok (Computed 3) }
expect tryApplyOperation Subtract 5 -2 == { rep: "5 - -2", outcome: Ok (Computed 7) }
expect tryApplyOperation Subtract Num.minI64 1 == { rep: "-9223372036854775808 - 1", outcome: Err Overflow }

expect tryApplyOperation Multiply 0 0 == { rep: "0 x 0", outcome: Ok (Computed 0) }
expect tryApplyOperation Multiply 0 5 == { rep: "0 x 5", outcome: Ok (Computed 0) }
expect tryApplyOperation Multiply 5 -1 == { rep: "5 x -1", outcome: Ok (Computed -5) }
expect tryApplyOperation Multiply Num.maxI64 0 == { rep: "9223372036854775807 x 0", outcome: Ok (Computed 0) }
expect tryApplyOperation Multiply Num.maxI64 1 == { rep: "9223372036854775807 x 1", outcome: Ok (Computed 9223372036854775807) }
expect tryApplyOperation Multiply Num.maxI64 2 == { rep: "9223372036854775807 x 2", outcome: Err Overflow }

expect tryApplyOperation DivTrunc 4 2 == { rep: "4 // 2", outcome: Ok (Computed 2) }
expect tryApplyOperation DivTrunc 2 4 == { rep: "2 // 4", outcome: Ok (Computed 0) }
expect tryApplyOperation DivTrunc 0 2 == { rep: "0 // 2", outcome: Ok (Computed 0) }
expect tryApplyOperation DivTrunc 2 0 == { rep: "2 // 0", outcome: Err DivByZero }

expect tryApplyOperation Remainder 0 3 == { rep: "0 % 3", outcome: Ok (Computed 0) }
expect tryApplyOperation Remainder 1 3 == { rep: "1 % 3", outcome: Ok (Computed 1) }
expect tryApplyOperation Remainder 2 3 == { rep: "2 % 3", outcome: Ok (Computed 2) }
expect tryApplyOperation Remainder 5 5 == { rep: "5 % 5", outcome: Ok (Computed 0) }
expect tryApplyOperation Remainder 5 0 == { rep: "5 % 0", outcome: Err DivByZero }

expect tryApplyOperation PowInt 0 0 == { rep: "0 ^ 0", outcome: Ok (UnsafeComputed 1) }
expect tryApplyOperation PowInt 10 2 == { rep: "10 ^ 2", outcome: Ok (UnsafeComputed 100) }
expect tryApplyOperation PowInt 2 10 == { rep: "2 ^ 10", outcome: Ok (UnsafeComputed 1024) }
