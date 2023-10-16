interface BasicCounter
    exposes [
        Count,
        from,
        inc,
        done,
    ]
    imports []
    
Count a := (U32, a)

from : a -> Count a
from = \advance ->
    @Count (0, advance)

inc : Count (U32 -> a) -> Count a
inc = \@Count (curr, advance) ->
    new = curr + 1

    @Count (new, advance new)

done : Count a -> a
done = \@Count (_, final) -> final

expect
    { foo, bar, baz } = 
        from {
            foo: <- inc,
            bar: <- inc,
            baz: <- inc,
        } |> done

    foo == 1 && bar == 2 && baz == 3

