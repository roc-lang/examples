app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br" }

import pf.Stdin
import pf.Stdout

main = readInput

# The ! suffix is syntax sugar for connecting tasks using Task.await.
#
# # Therefore, the following code:

readInput =
    Stdout.line! "Type in something and press Enter:"
    input = Stdin.line!
    Stdout.line! "Your input was: $(input)"
#
# desugars to this:
#
# readInput =
#     Task.await (Stdout.line "Type in something and press Enter:") \_ ->
#         Task.await Stdin.line \input ->
#             Stdout.line "Your input was: $(input)"
#
# Try commenting out the first block and uncommenting the second block.
# You will find that they behave exactly the same.
#
# For more information see the following:
#
# https://www.roc-lang.org/tutorial#the-!-suffix
# https://www.roc-lang.org/builtins/Task#await
