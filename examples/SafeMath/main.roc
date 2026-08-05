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
safe_variance : List(Dec) -> Try(Dec, [EmptyInputList, Overflow])
safe_variance = |maybe_empty_list| {
	# Check length to prevent division by zero
	match maybe_empty_list.len() {
		0 => Err(EmptyInputList)
		_ => {
			non_empty_list = maybe_empty_list

			# Length of list as a fraction (for compatibility in division)
			n = non_empty_list.len().to_dec()

			mean =
				non_empty_list # sum of all elements:
					.fold_try(0.0, |state, elem| elem.plus_try(state))
					.map_ok(|x| x / n)?

			non_empty_list
				.fold_try(
					0.0,
					|state, elem| {
						diff = elem.minus_try(mean)? # (X - µ)
						squared = times_try(diff, diff)? # (X - µ)²
						squared.plus_try(state) # ∑
					},
				)
				.map_ok(|x| x / n)
		}
	}
}

main! = |_| {
	variance_result =
		(
			[46, 69, 32, 60, 52, 41]
				|> safe_variance
		).map_ok(|v| v.to_str())
			.map_ok(|v| "σ² = ${v}")

	output_str =
		match variance_result {
			Ok(str) => str
			Err(EmptyInputList) => "Error: EmptyInputList: I can't calculate the variance over an empty list."
			Err(Overflow) => "Error: Overflow: When calculating the variance, a number got too large to store in the available memory for the type."
		}

	echo!("${output_str}\n")
	Ok({})
}

expect safe_variance([]) == Err(EmptyInputList)
expect safe_variance([0]) == Ok(0)
expect safe_variance([100]) == Ok(0)
expect safe_variance([4, 22, 99, 204, 18, 20]) == Ok(5032.138888888888888888)
expect safe_variance([46, 69, 32, 60, 52, 41]) == Ok(147.666666666666666666)

# The following function should soon be available in the Roc builtins
times_try : Dec, Dec -> Try(Dec, [Overflow, ..])
times_try = |a, b| {
	result = a.times_saturated(b)
	if result == Dec.lowest or result == Dec.highest {
		# For simplicity, some edge cases are ignored here, such as
		# Dec.highest.times_try(1)
		Err(Overflow)
	} else {
		Ok(result)
	}
}
