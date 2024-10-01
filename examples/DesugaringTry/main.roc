app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br" }

import pf.Stdout

main =
    Result.mapErr
        (getLetter "2")
        \_ -> Task.err (Exit 1 "Something went wrong")

# The ? suffix is syntax sugar for Result.try
#
# The following code:
getLetter : Str -> Result Str [OutOfBounds, InvalidNumStr]
getLetter = \indexStr ->
    index = Str.toU64? indexStr
    List.get ["a", "b", "c", "d"] index
#
# desugars to this:
#
# getLetter = \indexStr ->
#     Result.try (Str.toU64 indexStr) \index ->
#         List.get ["a", "b", "c", "d"] index
#
# Try commenting out the first block and uncommenting the second block.
# You will find that they behave exactly the same.
#
# For more information see the following:
#
# https://www.roc-lang.org/tutorial#error-handling
# https://www.roc-lang.org/builtins/Result#try
