app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import cli.Arg exposing [Arg]

main! : List Arg => Result {} _
main! = |_args|
    n_str = Num.to_str(least_square_difference)

    Stdout.line!("The least positive integer n, where the difference of n*n and (n-1)*(n-1) is greater than 1000, is ${n_str}")

## The smallest positive integer number `n`, where the difference
## of `n*n` and `(n-1)*(n-1)` is greater than 1000.
##
least_square_difference : U32
least_square_difference =
    find_number = |n|
        difference = (Num.pow_int(n, 2)) - (Num.pow_int((n - 1), 2))

        if difference > 1000 then
            n
        else
            find_number((n + 1))

    find_number(1)

expect least_square_difference == 501
