# Record Builder

Record builders are a syntax sugar for sequencing actions and collecting intermediate results as fields in a record.
All you need to build a record is a nominal type with a `map2` function that combines two builder values using a provided combiner function. There are many convenient APIs we can build with this simple syntax.

## The Basics

Let's assume we want to develop a module that parses any text with segments delimited by dashes, like `"Mar-10-2015"`.
The record builder pattern helps us parse each segment in its own way, and [short circuit](https://en.wikipedia.org/wiki/Short-circuit_evaluation) on the first failure.

> Note: it is possible to parse dash-delimited text in a specific format with simpler code.
However, generic APIs built with record builders can be much simpler and readable.

## Defining Types

We start by defining `Parser(a)`, which is a [parser combinator](https://en.wikipedia.org/wiki/Parser_combinator)
that takes a list of string segments to parse, and returns parsed data, as well as the remaining, unparsed segments:

```roc
Parser(a) : List(Str) -> Try((a, List(Str)), ParserErr)
```

All of the parsers that render to our builder's fields are `Parser` values, and get chained together into one big `Parser`.

> Notice that record builders all tend to deal with a single wrapping type, as we can only combine said values with our `map2` function if all combined values are the same type. On the plus side, this allows record builders to work with two fields, or ten, allowing for great composability.

We then define the nominal type `DateParser` holding `map2`, `parse_with`, `parse_str`, and `parse`.

## End Goal

It's useful to visualize our desired result. The record builder pattern we're aiming for looks like:

```roc
expect {
    date_parser = {
        month: DateParser.parse_str,
        day: DateParser.parse_with(U64.from_str),
        year: DateParser.parse_with(U64.from_str),
    }.DateParser

    DateParser.parse(date_parser, "Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })
}
```

This generates a record with fields `month`, `day`, and `year`, all possessing specific parts of the provided date. Note the `.DateParser` syntax appended to the record literal, specifying which nominal type provides the `map2` function to combine the fields into a single `Parser`.

## Under the Hood

The record builder pattern is [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar) which converts the previous code block into nested calls to `DateParser.map2`:

```roc
expect {
    date_parser =
        DateParser.map2(
            DateParser.parse_str,
            DateParser.map2(
                DateParser.parse_with(U64.from_str),
                DateParser.parse_with(U64.from_str),
                |day, year| (day, year),
            ),
            |month, (day, year)| { month, day, year },
        )

    DateParser.parse(date_parser, "Mar-10-2015") == Ok({ month: "Mar", day: 10, year: 2015 })
}
```

In short, we chain together all pairs of field values with the `map2` combining function, pairing them into tuples until the final grouping of values is structured as a record.

To make the above possible, we need to define `parse_with` to turn a segment converter into a `Parser`, `map2` to combine two `Parser`s in sequence, `parse_str` as a helper for plain string segments, and `parse` to break a string into segments and run the final `Parser`.

## Defining Our Functions

Let's start with `parse_with`:

```roc
parse_with : (Str -> Try(a, ParserErr)) -> Parser(a)
parse_with = |parser|
    |segments|
        match segments {
            [] => Err(OutOfSegments)
            [first, .. as rest] => {
                parsed = parser(first)?
                Ok((parsed, rest))
            }
        }
```

This parses the first segment available, and returns the parsed data along with all remaining segments not yet parsed.
We could already use this to parse a single-segment string without even using a record builder, but that wouldn't be very useful.
Let's see how our `map2` function manages combining two `Parser`s in sequence:

```roc
map2 : Parser(a), Parser(b), (a, b -> c) -> Parser(c)
map2 = |first, second, combiner|
    |segments| {
        (a, after_first) = first(segments)?
        (b, after_second) = second(after_first)?

        Ok((combiner(a, b), after_second))
    }
```

We parse the two groups (`first` and `second`), and then combine their results.

For convenience, `parse_str` wraps string segments without conversion:

```roc
parse_str : Parser(Str)
parse_str = DateParser.parse_with(|s| Ok(s))
```

Finally, we wrap up our parsers into `parse`, which breaks a string into segments delimited by `"-"` and applies our combined `Parser` on those segments:

```roc
parse : Parser(a), Str -> Try(a, ParserErr)
parse = |parser, text| {
    segments = Str.split_on(text, "-")
    (date, _remaining) = parser(segments)?

    Ok(date)
}
```

Now we're ready to use our parser as much as we want on any input text!

## Full Code

```roc
file:DateParser.roc
```

## Output

Code for the above example is available in `DateParser.roc` which you can run like this:

```sh
$ roc test DateParser.roc
All (2) tests passed in 11.2 ms.
```
