# Record Builder

Record builders are a syntax sugar for sequencing actions and collecting the intermediate results as fields in a record.
All you need to build a record is a `map2`-style function that takes two values of the same type and combines them using a provided combiner fnuction. There are many convenient APIs we can build with this simple syntax.

## The Basics

Let's assume we want to develop a module that parses any text with segments delimited by dashes, like "Mar-10-2015".
The record builder pattern can help us here to parse each segment in their own way, and [short circuit](https://en.wikipedia.org/wiki/Short-circuit_evaluation) on the first failure.

> Note: it is possible to parse dash-delimited text in a specific format with simpler code.
However, generic APIs built with record builders can be much simpler and readable.

## Defining Types

```roc
ParserGroup a := List Str -> Result (a, List Str) ParserErr
```

We start by defining a `ParserGroup`, which is a [parser combinator](https://en.wikipedia.org/wiki/Parser_combinator)
that takes a list of string segments to parse, and returns parsed data, as well as the remaining, unparsed segments.
All of the parsers that render to our builder's fields are `ParserGroup` values, and get chained together into one big `ParserGroup`.

You'll notice that record builders all tend to deal with a single wrapping type, as we can only combine said values with our `map2`-style function if all combined values are the same type. On the plus side, this allows record builders to work with a single value, two fields, or ten, allowing for great composability.

## End Goal

It's useful to visualize our desired result. The record builder pattern we're aiming for looks like:

```roc
expect
    date_parser =
        { chain_parsers <-
            month: parse_with(Ok),
            day: parse_with(Str.to_u64),
            year: parse_with(Str.to_u64),
        }
        |> build_segment_parser

    date_parser("Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })
```

This generates a record with fields `month`, `day`, and `year`, all possessing specific parts of the provided date.
Note the slight deviation from the conventional record syntax, with the `chain_parsers <-` at the top, which is our `map2`-style function.

## Under the Hood

The record builder pattern is [syntax sugar](https://en.wikipedia.org/wiki/Syntactic_sugar) which converts the previous code block into:

```roc
expect
    date_parser =
        build_segment_parser(chain_parsers(
            parse_with(Ok),
            chain_parsers(
                parse_with(Str.to_u64),
                parse_with(Str.to_u64),
                |day, year| (day, year),
            ),
            |month, (day, year)| { month, day, year },
        ))

    date_parser("Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })
```

In short, we chain together all pairs of field values with the `map2` combining function, pairing them into tuples until the final grouping of values is structured as a record.

To make the above possible, we'll need to define the `parse_with` function that turns a parser into a `ParserGroup`, and the `chain_parsers` function that acts as our `map2` combining function.

## Defining Our Functions

Let's start with `parse_with`:

```roc
parse_with : (Str -> Result a ParserErr) -> ParserGroup a
parse_with = |parser|
    @ParserGroup(
        |segments|
            when segments is
                [] -> Err(OutOfSegments)
                [first, .. as rest] ->
                    parsed = parser(first)?
                    Ok((parsed, rest)),
    )
```

This parses the first segment available, and returns the parsed data along with all remaining segments not yet parsed.
We could already use this to parse a single-segment string without even using a record builder, but that wouldn't be very useful.
Let's see how our `chain_parsers` function will manage combining two `ParserGroup`s in serial:

```roc
chain_parsers : ParserGroup a, ParserGroup b, (a, b -> c) -> ParserGroup c
chain_parsers = |@ParserGroup(first), @ParserGroup(second), combiner|
    @ParserGroup(
        |segments|
            (a, after_first) = first(segments)?
            (b, after_second) = second(after_first)?

            Ok((combiner(a, b), after_second)),
    )
```

We parse the two groups (see `first` and `second`), and then combine their results.

Finally, we'll need to wrap up our parsers into one that breaks a string into segments and then applies our parsers on those segments.
We can call it `build_segment_parser`:

```roc
build_segment_parser : ParserGroup a -> (Str -> Result a ParserErr)
build_segment_parser = |@ParserGroup(parser_group)|
    |text|
        segments = Str.split_on(text, "-")
        (date, _remaining) = parser_group(segments)?

        Ok(date)
```

Now we're ready to use our parser as much as we want on any input text!

## Full Code

```roc
file:DateParser.roc
```

## Output

Code for the above example is available in `DateParser.roc` which you can run like this:

```sh
% roc test DateParser.roc

0 failed and 2 passed in 190 ms.
```
