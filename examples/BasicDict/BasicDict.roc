interface BasicDict
    exposes []
    imports []

# the dictionary type is: Dict key value
# Both key and value are type variables

# Below we use a Str key for the fruit name, and a U64 value for the fruit count.
fruitDict : Dict Str U64
fruitDict =
    Dict.empty {}
    |> Dict.insert "Apple" 3
    |> Dict.insert "Banana" 2

expect
    # get the value for a key
    # Dict.get returns a Result with either `Ok value` or `Err KeyNotFound`
    Dict.get fruitDict "Apple" == (Ok 3)

expect
    # get the length (number of key-value pairs) of a Dict
    Dict.len fruitDict == 2

expect
    # convert Dict to a Str
    Inspect.toStr fruitDict == "{\"Apple\": 3, \"Banana\": 2}"

expect
    # get all the keys
    Dict.keys fruitDict == ["Apple", "Banana"]

expect
    # get all the values
    Dict.values fruitDict == [3, 2]

expect
    # convert to a list of tuples
    Dict.toList fruitDict == [("Apple", 3), ("Banana", 2)]

expect
    # remove a key-value pair
    Dict.remove fruitDict "Apple"
    |> Dict.remove "Banana"
    |> Dict.isEmpty

expect
    # update the value of a Dict
    updatedDict =
        Dict.update fruitDict "Apple" addFruit

    # We need to account for the case when a key (=fruit) is not in the Dict.
    # So we need a function like this:
    addFruit : [Present U64, Missing] -> [Present U64, Missing]
    addFruit = \valueTag ->
        when valueTag is
            # If the fruit is not in the dict (=missing), we set the count to 1
            Missing -> Present 1
            # If the fruit is in the dict (=present), we increase the count
            Present count -> Present (count + 1)

    Dict.get updatedDict "Apple" == (Ok 4)

# see https://www.roc-lang.org/builtins/Dict for more
