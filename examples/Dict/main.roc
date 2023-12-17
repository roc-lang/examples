app "dict-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.0/bkGby8jb0tmZYsy2hg1E_B2QrCgcSTxdUlHtETwm5m4.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

# An empty Dict
emptyDict =
    Dict.empty {}

# A Dict(ionary) can have any data type for keys, but all keys need to have the same type.
# In the following Dict I am using Str.
#
# It also can have any data type for the values, but all the values need to have the same type.
# In the following Dict I am using Num
#
# You can use Dict.insert to add (key, values) pairs to the Dict.
aDict =
    emptyDict
    |> Dict.insert "Banana" 0
    |> Dict.insert "Apple" 0

# Let's render the Dict into a Str
toStr = \dict ->
    if Dict.isEmpty dict then
        "(Not much to display, this Dict is empty!)"
    else
        dict
        |> Dict.toList
        |> List.map (\pair -> "- \(pair.0): \(Num.toStr pair.1)")
        |> Str.joinWith "\n"

aListOfFruit = ["Banana", "Pear", "Apple", "Apple", "Pear", "Banana", "Apple", "Apple"]

# Let's count our fruits
countDict =
    aListOfFruit
    |> List.walk emptyDict (\dict, fruit -> inc dict fruit)

# The Dict.update function is ideal for bulding a Dict one item at the time
inc = \dict, key ->
    Dict.update dict key \value ->
        when value is
            # If the key is not present, yet. I can add it
            Missing -> Present 1
            # If the key is present, I can update its value
            Present v -> Present (v+1)

output =
    """
    emptyDict:
    \(emptyDict |> toStr)

    aDict:
    \(aDict |> toStr)

    countDict:
    \(countDict |> toStr)
    """

main = 
    Stdout.line output
