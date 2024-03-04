interface Hello
    # Only what's in 'exposes' is accessible to other modules
    exposes [hello]
    imports []

hello : Str -> Str
hello = \name ->
    "Hello $(name) from interface!"
