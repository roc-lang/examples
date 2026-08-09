main! = |_| Ok({})

# the dictionary type is: Dict(key, value)
# Both key and value are type variables

# Below we use a Str key for the fruit name, and a U64 value for the fruit count.
fruit_dict : Dict(Str, U64)
fruit_dict =
	Dict.empty()
		.insert("Apple", 3)
		.insert("Banana", 2)

expect
# get the value for a key
# Dict.get returns a Try with either `Ok(value)` or `Err(KeyNotFound)`
	fruit_dict.get("Apple") == Ok(3)

expect
# get the length (number of key-value pairs) of a Dict
	fruit_dict.len() == 2

expect
# get all the keys
	fruit_dict.keys() == ["Apple", "Banana"]

expect
# get all the values
	fruit_dict.values() == [3, 2]

expect
# convert to a list of tuples
	fruit_dict.to_list() == [("Apple", 3), ("Banana", 2)]

expect
# remove a key-value pair
	fruit_dict.remove("Apple").remove("Banana").is_empty()

expect {
	# update the value of a Dict
	# We need to account for the case when a key (=fruit) is not in the Dict.
	# So we need a function like this:
	add_fruit : Try(U64, [Missing]) -> Try(U64, [Missing])
	add_fruit = |value_tag|
		match value_tag {
			# If the fruit is not in the dict (=missing), we set the count to 1
			Err(Missing) => Ok(1)
			# If the fruit is in the dict, we increase the count
			Ok(count) => Ok(count + 1)
		}

	updated_dict = fruit_dict.update("Apple", add_fruit)

	updated_dict.get("Apple") == Ok(4)
}

# see https://www.roc-lang.org/docs/main/Dict/ for more
