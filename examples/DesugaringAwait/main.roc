app [main!] { pf: platform "../../../basic-cli/platform/main.roc" }

import pf.Stdin
import pf.Stdout

# TODO update README ... for this example

main! = \_ ->
    try hello! {}
    try read_input! {}

    Ok {}

### start snippet bang
hello! = \_ ->
    try Stdout.line! "Hello Alice"
    Stdout.line! "Hello Bob"
### end snippet bang

### start snippet bangInput
read_input! = \_ ->
    try Stdout.line! "Type in something and press Enter:"
    input = try Stdin.line! {}
    Stdout.line! "Your input was: $(input)"
### end snippet bangInput
