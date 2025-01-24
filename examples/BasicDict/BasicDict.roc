module []

# the dictionary type is: Dict key value
# Both key and value are type variables

# Below we use a Str key for the fruit name, and a U64 value for the fruit count.
fruit_dict : Dict Str U64
fruit_dict =
    Dict.empty({})
    |> Dict.insert("Apple", 3)
    |> Dict.insert("Banana", 2)

expect
    # get the value for a key
    # Dict.get returns a Result with either `Ok value` or `Err KeyNotFound`
    Dict.get(fruit_dict, "Apple") == (Ok(3))

expect
    # get the length (number of key-value pairs) of a Dict
    Dict.len(fruit_dict) == 2

expect
    # convert Dict to a Str
    Inspect.to_str(fruit_dict) == "{\"Apple\": 3, \"Banana\": 2}"

expect
    # get all the keys
    Dict.keys(fruit_dict) == ["Apple", "Banana"]

expect
    # get all the values
    Dict.values(fruit_dict) == [3, 2]

expect
    # convert to a list of tuples
    Dict.to_list(fruit_dict) == [("Apple", 3), ("Banana", 2)]

expect
    # remove a key-value pair
    Dict.remove(fruit_dict, "Apple")
    |> Dict.remove("Banana")
    |> Dict.is_empty

expect
    # update the value of a Dict
    updated_dict =
        Dict.update(fruit_dict, "Apple", add_fruit)

    # We need to account for the case when a key (=fruit) is not in the Dict.
    # So we need a function like this:
    add_fruit : Result U64 [Missing] -> Result U64 [Missing]
    add_fruit = |value_tag|
        when value_tag is
            # If the fruit is not in the dict (=missing), we set the count to 1
            Err(Missing) -> Ok(1)
            # If the fruit is in the dict, we increase the count
            Ok(count) -> Ok((count + 1))

    Dict.get(updated_dict, "Apple") == (Ok(4))

# see https://www.roc-lang.org/builtins/Dict for more
