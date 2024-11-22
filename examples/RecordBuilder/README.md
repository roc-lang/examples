# Record Builder 

Record builders are a syntax sugar for sequencing actions and collecting the intermediate results as fields in a record. All you need to build a record is a `map2`-style function that takes two values of the same type and combines them using a provided combiner fnuction. There are many convenient APIs we can build with this simple syntax.

## The Basics

Let's assume we want to develop a module that parses any text with segments delimited by dashes. The record builder pattern can help us here to parse each segment in their own way, and short circuit on the first failure.

> Note: it is possible to parse dash-delimited text in a specific format with simpler code. However, generic APIs built with record builders can be much simpler and readable than any such specific implementation.

## Defining Types

```roc
ParserGroup a := List Str -> Result (a, List Str) ParserErr
```

We start by defining a `ParserGroup`, which is a [parser combinator](https://en.wikipedia.org/wiki/Parser_combinator) that takes in a list of string segments to parse, and returns parsed data as well as the remaining, unparsed segments. All of the parsers that render to our builder's fields are `ParserGroup` values, and get chained together into one big `ParserGroup`.

You'll notice that record builders all tend to deal with a single wrapping type, as we can only combine said values with our `map2`-style function if all combined values are the same type. On the plus side, this allows record builders to work with a single value, two fields, or ten, allowing for great composability.

## End Goal

It's useful to visualize our desired result. The record builder pattern we're aiming for looks like:

```roc
expect
    dateParser : ParserGroup Date
    dateParser =
        { chainParsers <-
            month: parseWith Ok,
            day: parseWith Str.toU64,
            year: parseWith Str.toU64,
        }
        |> buildSegmentParser

    date = dateParser "Mar-10-2015"

    date == Ok { month: "Mar", day: 10, year: 2015 }
```

This generates a record with fields `month`, `day`, and `year`, all possessing specific parts of the provided date. Note the slight deviation from the conventional record syntax, with the `chainParsers <-` at the top, which is our `map2`-style function.

## Under the Hood

The record builder pattern is syntax sugar which converts the preceding into:

```roc
expect
    dateParser : ParserGroup Date
    dateParser =
        chainParsers
            (parseWith Ok)
            (chainParsers
                (parseWith Str.toU64)
                (parseWith Str.toU64)
                (\day, year -> (day, year))
            )
            (\month, (day, year) -> { month, day, year })
```

In short, we chain together all pairs of field values with the `map2` combining function, pairing them into tuples until the final grouping of values is structured as a record.

To make the above possible, we'll need to define the `parseWith` function that turns a parser into a `ParserGroup`, and the `chainParsers` function that acts as our `map2` combining function.

## Defining Our Functions

Let's start with `parseWith`:

```roc
parseWith : (Str -> Result a ParserErr) -> ParserGroup a
parseWith = \parser ->
    @ParserGroup \segments ->
        when segments is
            [] -> Err OutOfSegments
            [first, .. as rest] ->
                parsed = parser? first
                Ok (parsed, rest)
```

This parses the first segment available, and returns the parsed data along with all remaining segments not yet parsed. We could already use this to parse a single-segment string without even using a record builder, but that wouldn't be very useful. Let's see how our `chainParsers` function will manage combining two `ParserGroup`s in serial:

```roc
chainParsers : ParserGroup a, ParserGroup b, (a, b -> c) -> ParserGroup c
chainParsers = \@ParserGroup first, @ParserGroup second, combiner ->
    @ParserGroup \segments ->
        (a, afterFirst) = first? segments
        (b, afterSecond) = second? afterFirst

        Ok (combiner a b, afterSecond)
```

Just parse the two groups, and then combine their results? That was easy!

Finally, we'll need to wrap up our parsers into one that breaks a string into segments and then applies our parsers on said segments. We can call it `buildSegmentParser`:

```roc
buildSegmentParser : ParserGroup a -> (Str -> Result a ParserErr)
buildSegmentParser = \@ParserGroup parserGroup ->
    \text ->
        segments = Str.splitOn text "-"
        (date, _remaining) = parserGroup? segments

        Ok date
```

Now we're ready to use our parser as much as we want on any input text!

## Full Code

```roc
file:DateParser.roc
```

## Output

Code for the above example is available in `DateParser.roc` which you can run like this:

```sh
% roc test IDCounter.roc

0 failed and 1 passed in 190 ms.
```
