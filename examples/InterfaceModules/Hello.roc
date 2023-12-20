interface Hello
    # Only the functions exposed by 'expose' are visable from the outside
    exposes [hello]
    imports []

hello : Str -> Str
hello = \name ->
    "Hello \(name) from interface!"

expect hello "someone" == "Hello someone from interface!"
