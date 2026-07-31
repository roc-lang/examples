main! = |_| {
	# a tuple that contains three different types
	simple_tuple : (Str, Bool, I64)
	simple_tuple = ("A String", Bool.True, 15_000_000)

	# access the items in a tuple by index (starts at 0)
	first_item = simple_tuple.0
	second_item = if simple_tuple.1 {
		"True"
	} else {
		"False"
	}
	third_item = simple_tuple.2.to_str()

	echo!("First is: ${first_item},\nSecond is: ${second_item},\nThird is: ${third_item}.\n")

	# You can also use tuples with `match`:
	fruit_selection : [Apple, Pear, Banana]
	fruit_selection = Pear

	quantity = 12

	match (fruit_selection, quantity) {
		(_, qty) if qty == 0 => echo!("You have no fruit.\n")
		(Apple, _) => echo!("You also have some apples.\n")
		(Pear, _) => echo!("You also have some pears.\n")
		(Banana, _) => echo!("You also have some bananas.\n")
	}

	Ok({})
}
