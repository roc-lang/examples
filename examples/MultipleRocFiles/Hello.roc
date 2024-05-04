module
    # Only what's listed here is accessible/exposed to other modules
    [hello]

hello : Str -> Str
hello = \name ->
    "Hello $(name) from interface!"
