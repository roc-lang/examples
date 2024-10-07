app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.15.0/SlwdbJ-3GR7uBWQo6zlmYWNYOxnvo8r6YABXD-45UOw.tar.br" }

import pf.Stdin
import pf.Stdout

main =
    helloBang!
    helloAwait!
    readInputBang!
    readInputAwait!

### start snippet bang
helloBang =
    Stdout.line! "Hello Alice"
    Stdout.line "Hello Bob"
### end snippet bang

helloAwait =
    ### start snippet await
    Task.await (Stdout.line "Hello Alice") \_ ->
        Stdout.line "Hello Bob"
### end snippet await

### start snippet bangInput
readInputBang =
    Stdout.line! "Type in something and press Enter:"
    input = Stdin.line!
    Stdout.line! "Your input was: $(input)"
### end snippet bangInput

### start snippet awaitInput
readInputAwait =
    Task.await (Stdout.line "Type in something and press Enter:") \_ ->
        Task.await Stdin.line \input ->
            Stdout.line "Your input was: $(input)"
### end snippet awaitInput
