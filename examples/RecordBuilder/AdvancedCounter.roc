interface AdvancedCounter
    exposes []
    imports []
    
Count a := (Nat, a)

from : Nat, a -> Count a
from = \value, a ->
    @Count (value, a)

incBy : Nat -> (Count (Nat -> a) -> Count a)
incBy = \value -> \@Count (curr, advance) ->
    new = curr + value

    @Count (new, advance new)

done : Count a -> a
done = \@Count (_, final) -> final

expect
    { foo, bar, baz } =
        from 0 {
            foo: <- incBy 2,
            bar: <- incBy 3,
            baz: <- incBy 4,
        } |> done

    foo == 2 && bar == 5 && baz == 9
