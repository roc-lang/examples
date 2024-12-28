app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br" }

import pf.Stdout

main! = \_ ->

    # a tuple that contains different types
    simple_tuple : (Str, Bool, I64)
    simple_tuple = ("A String", Bool.true, 15_000_000)

    # access the items in a tuple by index (starts at 0)
    first_item = simple_tuple.0
    second_item = if simple_tuple.1 then "true" else "false"
    third_item = Num.toStr simple_tuple.2

    try
        Stdout.line!
        """
        First is: $(first_item),
        Second is: $(second_item),
        Third is: $(third_item).
        """

    # You can also use tuples with `when`:
    fruit_selection : [Apple, Pear, Banana]
    fruit_selection = Pear

    quantity = 12

    when (fruit_selection, quantity) is
        # TODO re-enable when github.com/roc-lang/roc/issues/5530 is fixed.
        # (_, qty) if qty == 0 -> Stdout.line! "You also have no fruit."
        (Apple, _) -> Stdout.line! "You also have some apples."
        (Pear, _) -> Stdout.line! "You also have some pears."
        (Banana, _) -> Stdout.line! "You also have some bananas."
