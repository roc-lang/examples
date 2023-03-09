# Parser Example

**URL Packages.** This application uses the `roc-lang/basic-cli` platform and a Parser package to demonstrate a how to build and use a custom parser to handle UTF8 input. It also demonstrates how Roc code can be organised into separate Interface modules and imported as a package.

You can run this example with `roc run hello-letters.roc`.

**Unit Testing.** This example also demonstrats how to create a unit test for a Roc module using the `expect` keyword. Unit tests are an excellent way to develop using test driven development, and also protect against any future regression in functionality. You can run the tests in this example usin the command `roc test hello-letters.roc`.

Below is an example of a unit test from the example.

```coffee
# Test we can parse a number of different letters
expect
    input = "BCXA"
    parser = many letterParser
    result = parseStr parser input
    result == Ok [B, C, Other, A]
```

**Documentation Comments.** This examples shows how Roc code can be documented to communicate effectively with users of a package. The `/package/ParserCore.roc` Interface module has multiple examples of documentation comments. You can generate documentation using the Roc cli with the command `roc docs package/main.roc`. 

Below is an example of a documentation comment on a function.

```coffee
## Runs a parser for an 'opening' delimiter, then your main parser, then the 'closing' delimiter,
## and only returns the result of your main parser.
##
## Useful to recognize structures surrounded by delimiters (like braces, parentheses, quotes, etc.)
## ```
## betweenBraces  = \parser -> parser |> between (scalar '[') (scalar ']')
## ```
```