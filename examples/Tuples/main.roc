app "tuples-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
    ]
    provides [main] to pf

main = 

    # This is a tuple, note that it contains different types
    simpleTuple = ("A String", 0xAB01, 15_000_000i64)

    # You can access the items in a tuple by index, note that it starts at zero
    firstItem = simpleTuple.0
    secondItem = Num.toStr simpleTuple.1
    thirdItem = Num.toStr simpleTuple.2

    {} <- Stdout.line 
        """
        First is: \(firstItem),
        Second is: \(secondItem), 
        Third is: \(thirdItem).
        """
        |> Task.await

    fruitSelection : [Apple, Pear, Banana]
    fruitSelection = Pear

    qty : U32
    qty = 12

    # You can also use tuples in pattern matching
    when (fruitSelection, qty) is 
        (_, a) if a == 0 -> Stdout.line "You also have no fruit"
        (Apple, _) -> Stdout.line "You also have some apples"
        (Pear, _) -> Stdout.line "You also have some pears"
        (Banana, _) -> Stdout.line "You also have some bananas"
        (_,_) -> crash "unrecongized fruit selection"



