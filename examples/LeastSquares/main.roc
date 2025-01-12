app [main!] { cli: platform "../../../basic-cli/platform/main.roc" }

import cli.Stdout

main! = \_args ->
    n_str = Num.to_str(least_square_difference)

    Stdout.line!("The least positive integer n, where the difference of n*n and (n-1)*(n-1) is greater than 1000, is $(n_str)")

## The smallest positive integer number `n`, where the difference
## of `n*n` and `(n-1)*(n-1)` is greater than 1000.
##
least_square_difference : U32
least_square_difference =
    find_number = \n ->
        difference = (Num.pow_int(n, 2)) - (Num.pow_int((n - 1), 2))

        if difference > 1000 then
            n
        else
            find_number((n + 1))

    find_number(1)

expect least_square_difference == 501
