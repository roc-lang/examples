## An immutable counter. Start with [zero], then call [increment].
Counter := { value : U64 }.{

	## A counter with no increments.
	zero : Counter
	zero = { value: 0 }

	## Return a counter whose value is one larger.
	increment : Counter -> Counter
	increment = |counter| { value: counter.value + 1 }
}
