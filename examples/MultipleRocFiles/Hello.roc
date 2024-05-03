module
    # Only what's in 'exposes' is accessible to other modules
    [hello]

hello : Str -> Str
hello = \name ->
    "Hello $(name) from interface!"
