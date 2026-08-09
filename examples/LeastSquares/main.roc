main! = |_| {
	n_str = least_square_difference.to_str()
	echo!("The least positive integer n, where the difference of n*n and (n-1)*(n-1) is greater than 1000, is ${n_str}\n")
	Ok({})
}

## The smallest positive integer number `n`, where the difference
## of `n*n` and `(n-1)*(n-1)` is greater than 1000.
##
least_square_difference : U32
least_square_difference = {
	find_number = |n| {
		difference = (n * n) - ((n - 1) * (n - 1))
		if difference > 1000 {
			n
		} else {
			find_number(n + 1)
		}
	}

	find_number(1)
}

expect least_square_difference == 501
