app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0-testing/libzR-AkVEn_dTBg2bKuXqMNZ9rYEfz3HSEQU8inoGk.tar.br" }

import pf.Stdout

main =

    # a tuple that contains different types
    simpleTuple : (Str, Bool, I64)
    simpleTuple = ("A String", Bool.true, 15_000_000)

    # access the items in a tuple by index (starts at 0)
    firstItem = simpleTuple.0
    secondItem = if simpleTuple.1 then "true" else "false"
    thirdItem = Num.toStr simpleTuple.2
    Stdout.line!
        """
        First is: $(firstItem),
        Second is: $(secondItem), 
        Third is: $(thirdItem).
        """

    # You can also use tuples with `when`:
    fruitSelection : [Apple, Pear, Banana]
    fruitSelection = Pear

    quantity = 12

    when (fruitSelection, quantity) is
        # TODO re-enable when github.com/roc-lang/roc/issues/5530 is fixed.
        # (_, qty) if qty == 0 ->
        #    Stdout.line! "You also have no fruit."
        (Apple, _) ->
            Stdout.line! "You also have some apples."

        (Pear, _) ->
            Stdout.line! "You also have some pears."

        (Banana, _) ->
            Stdout.line! "You also have some bananas."

