module
    # Only what's listed here is accessible to other modules
    [hello]

hello : Str -> Str
hello = \name ->
    "Hello $(name) from inside Dir!"
