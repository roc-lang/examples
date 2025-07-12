app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import cli.Arg exposing [Arg]

# Note: I tried to demonstrate all Roc syntax (possible in a single app file), but I probably forgot some things.

# Note: Do not include this file in an LLM prompt, this file does not demonstrate best practices.

number_operators : I64, I64 -> _
number_operators = |a, b|
    a_f64 = Num.to_f64(a)
    b_f64 = Num.to_f64(b)

    {
        # binary operators
        sum: a + b,
        diff: a - b,
        prod: a * b,
        div: a_f64 / b_f64,
        div_trunc: a // b,
        rem: a % b,
        eq: a == b,
        neq: a != b,
        lt: a < b,
        lteq: a <= b,
        gt: a > b,
        gteq: a >= b,
        # unary operators
        neg: -a, # the last item can have a comma too
    }

boolean_operators : Bool, Bool -> _
boolean_operators = |a, b|
    {
        bool_and: a && b,
        bool_and_keyword: a and b,
        bool_or: a || b,
        bool_or_keyword: a or b,
        not_a: !a
    }

pizza_operator : Str, Str -> Str
pizza_operator = |str_a, str_b|
    str_a |> Str.concat(str_b)

patterns : List U64 -> U64
patterns = |lst|
    when lst is
        [1, 2, ..] ->
            42
        [2, .., 1] ->
            24
        [] ->
            0
        [_head, .. as tail] ->
            List.len(tail)
        # Note: avoid using `_` in a when branch, in general you should try to match all cases explicitly. 
        _ ->
            100

pattern_match_tag_union : Result {} _ -> Str
pattern_match_tag_union = |result|
    # `Result a b` is the tag union `[Ok a, Err b]` under the hood.
    when result is
        Ok(_) ->
            "Success"
        Err(StdoutErr(err)) ->
            "StdoutErr: ${Inspect.to_str(err)}" 
        Err(_) ->
            "Unknown error"

# TODO when branch with tag union, strings, tuples...

# end name with `!` for effectful functions
# `=>` shows effectfulness in the type signature 
effect_demo! : Str => Result {} [ StdoutErr _, StdoutLineFailed [StdoutErr _] ]
effect_demo! = |msg|

    # `?` to return the error if there is one
    Stdout.line!(msg)?
    
    # ` ? ` for map_err
    Stdout.line!(msg) ? |err| StdoutLineFailed(err)

    # ?? to provide default value
    Stdout.line!(msg) ?? {}

    # In rare cases, you can use `_ =` to ignore the result. This allows you to avoid StdoutErr in the type signature.
    # Example of appropriate usage: https://github.com/roc-lang/basic-webserver/blob/main/platform/main.roc
    _ = Stdout.line!(msg)

    Ok({})

dbg_expect_crash : {} -> {}
dbg_expect_crash = |{}|
    a = 42

    dbg a

    # dbg can forward what it receives
    b = dbg 43
    
    # inline expects get removed in optimized builds!
    expect b == 43

    crash "Avoid using crash in production software!"

# Top level expect
expect 0 == 0

if_demo : Bool -> Str
if_demo = |cond|
    # every if must have an else branch!

    one_line_if = if cond then "True" else "False"

    # multiline if
    if cond then
        one_line_if
    else
        "False"

tuple_demo : {} -> (Str, U32)
tuple_demo = |{}|
    # tuples can contain mutltiple types
    # they are allocated on the stack
    ("Roc", 1)

# TODO: destructuring tuples, records

tag_union_demo : Str -> [Red, Green, Yellow]
tag_union_demo = |string|
    when string is
        "red" -> Red
        "green" -> Green
        # We can't list all possible strings, so we use `_` to match all other cases.
        _ -> Yellow

main! : List Arg => Result {} _
main! = |_args|
    Stdout.line!("${Inspect.to_str(number_operators(10, 5))}")?
    Stdout.line!("${Inspect.to_str(boolean_operators(Bool.true, Bool.false))}")?

    pizza_out = pizza_operator("Pizza ", "Roc")
    Stdout.line!("${Inspect.to_str(pizza_out)}")?

    Stdout.line!("${Inspect.to_str(patterns([1, 2, 3, 4]))}")?
    Stdout.line!("${Inspect.to_str(pattern_match_tag_union(Ok({})))}")?
    Stdout.line!("${Inspect.to_str(effect_demo!("Hello, world!"))}")?
    Stdout.line!("${Inspect.to_str(if_demo(Bool.true))}")?
    Stdout.line!("${Inspect.to_str(tuple_demo({}))}")?
    Stdout.line!("${Inspect.to_str(tag_union_demo("red"))}")?
    Stdout.line!("${Inspect.to_str(dbg_expect_crash({}))}")

