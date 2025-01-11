app [main!] { pf: platform "../../../basic-cli/platform/main.roc" }

import pf.Stdout

main! = \_args ->

    # a tuple that contains three different types
    simple_tuple : (Str, Bool, I64)
    simple_tuple = ("A String", Bool.true, 15_000_000)

    # access the items in a tuple by index (starts at 0)
    first_item = simple_tuple.0
    second_item = if simple_tuple.1 then "true" else "false"
    third_item = Num.to_str(simple_tuple.2)

    Stdout.line!(
        """
        First is: $(first_item),
        Second is: $(second_item),
        Third is: $(third_item).
        """
    )?

    # You can also use tuples with `when`:
    fruit_selection : [Apple, Pear, Banana]
    fruit_selection = Pear

    quantity = 12

    when (fruit_selection, quantity) is
        # TODO re-enable when github.com/roc-lang/roc/issues/5530 is fixed.
        # (_, qty) if qty == 0 -> Stdout.line! "You have no fruit."
        (Apple, _) -> Stdout.line!("You also have some apples.")
        (Pear, _) -> Stdout.line!("You also have some pears.")
        (Banana, _) -> Stdout.line!("You also have some bananas.")
