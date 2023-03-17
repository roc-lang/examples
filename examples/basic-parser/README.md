# Parser Example

This example builds a custom parser for counting letters.  

```roc
main.roc
```

## Secondary Notes

**URL Packages.** This application uses the `roc-lang/basic-cli` platform and a Parser package to demonstrate a how to build and use a custom parser to handle UTF8 input. It also demonstrates how Roc code can be organised into separate Interface modules and imported as a package.

You can run this example with `roc run main.roc`.

**Unit Testing.** This example also demonstrates how to create a unit test for a Roc module using the `expect` keyword. Unit tests are an excellent way to develop using test driven development, and also protect against any future regression in functionality. You can run the tests in this example usin the command `roc test main.roc`.

Below is an example of a unit test from the example.

```roc
# Test we can parse a number of different letters
expect
    input = "BCXA"
    parser = many letterParser
    result = parseStr parser input
    result == Ok [B, C, Other, A]
```

**Documentation Comments.** This example shows how Roc code can be documented to communicate effectively with users of a package. The `/package/ParserCore.roc` Interface module has multiple examples of documentation comments. You can generate documentation using the Roc cli with the command `roc docs /package/main.roc`. 

Below is an example of a documentation comment on a function.

```roc
## Skip over a parsed item as part of a pipeline
##
## This is useful if you are using a pipeline of parsers with `keep` but
## some parsed items are not part of the final result
## ```
## const (\x -> \y -> \z -> Triple x y z)
##     |> keep Parser.Str.nat
##     |> skip (codeunit ',')
##     |> keep Parser.Str.nat
##     |> skip (codeunit ',')
##     |> keep Parser.Str.nat
## ```
skip : Parser input kept, Parser input skipped -> Parser input kept
```

