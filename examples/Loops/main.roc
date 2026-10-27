app [] {
	roc: "nightly-2026-10-27-de79a0f",
}

### start snippet example
sum_for : List(I64) -> I64
sum_for = |numbers| {
	var $total = 0
	for n in numbers {
		$total = $total + n
	}
	$total
}

sum_while : List(I64) -> I64
sum_while = |numbers| {
	var $total = 0
	var $remaining = numbers
	while !$remaining.is_empty() {
		match $remaining {
			[n, .. as rest] => {
				$total = $total + n
				$remaining = rest
			}
			[] => break
		}
	}
	$total
}

sum_fold : List(I64) -> I64
sum_fold = |numbers| numbers.fold(0, |total, n| total + n)

expect sum_for([1, 2, 3]) == 6
expect sum_while([1, 2, 3]) == 6
expect sum_fold([1, 2, 3]) == 6
expect sum_while([]) == 0
### end snippet example
