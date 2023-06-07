app "tuples-example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
    ]
    provides [main] to pf

main = 

    # a tuple that contains different types
    simpleTuple : ( Str, F64, I64 )
    simpleTuple = ("A String", 4.2, 15_000_000)

    # access the items in a tuple by index (starts at 0)
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

    # You can also use tuples with `when`:
    fruitSelection : [Apple, Pear, Banana]
    fruitSelection = Pear

    quantity = 12

    when (fruitSelection, quantity) is
        # TODO re-enable when github.com/roc-lang/roc/issues/5530 is fixed
        #(_, qty) if qty == 0 ->
        #    Stdout.line "You also have no fruit."
        (Apple, _) ->
            Stdout.line "You also have some apples."
        (Pear, _) ->
            Stdout.line "You also have some pears."
        (Banana, _) ->
            Stdout.line "You also have some bananas."
