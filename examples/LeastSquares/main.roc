app "example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br" }
    imports [
        pf.Stdout,
    ]
    provides [main] to pf

main =
    nStr = Num.toStr (leastSquareDifference {})

    Stdout.line "The least positive integer n, where the difference of n*n and (n-1)*(n-1) is greater than 1000, is $(nStr)"

## A recursive function that takes an `U32` as its input and returns the least
## positive integer number `n`, where the difference of `n*n` and `(n-1)*(n-1)`
## is greater than 1000.
##
## The input `n` should be a positive integer, and the function will return an
## `U32`representing the least positive integer that satisfies the condition.
##
leastSquareDifference : {} -> U32
leastSquareDifference = \_ ->
    findNumber = \n ->
        difference = (Num.powInt n 2) - (Num.powInt (n - 1) 2)

        if difference > 1000 then
            n
        else
            findNumber (n + 1)

    findNumber 1

expect leastSquareDifference {} == 501
