app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.20.0/X73hGh05nNTkDHU06FHC0YfFaQB1pimX7gncRcao5mU.tar.br" }

import cli.Stdout
import cli.Stdout as StdoutAlias
import cli.Arg exposing [Arg]
import "README.md" as readme : Str # You can also import as List U8

# Note 1: I tried to demonstrate all Roc syntax (possible in a single app file),
# but I probably forgot some things.

# Note 2: Lots of syntax patterns are better explained in their own dedicated example,
# see https://www.roc-lang.org/examples/ 

## Double hashtag for doc comment
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
        neg: -a,
        # the last item can have a comma too
    }

boolean_operators : Bool, Bool -> _
boolean_operators = |a, b| {
    bool_and: a && b,
    bool_and_keyword: a and b,
    bool_or: a || b,
    bool_or_keyword: a or b,
    not_a: !a,
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

        [_head, .. as tail] if List.len(tail) > 7 ->
            List.len(tail)

        # Note: avoid using `_` in a when branch, in general you should
        # try to match all cases explicitly.
        _ ->
            100

string_stuff : Str
string_stuff =
    planet = "Venus"

    Str.concat(
        "Hello, ${planet}!",
        """
        This is a multiline string.
        You can call functions inside $... too: ${Num.to_str(1 + 1)}
        Unicode escape sequence: \u(00A0)
        """,
    )

pattern_match_tag_union : Result {} [StdoutErr(Str), Other] -> Str
pattern_match_tag_union = |result|
    # `Result a b` is the tag union `[Ok a, Err b]` under the hood.
    when result is
        Ok(_) ->
            "Success"

        Err(StdoutErr(err)) ->
            "StdoutErr: ${Inspect.to_str(err)}"

        Err(_) ->
            "Unknown error"

# end name with `!` for effectful functions
# `=>` shows effectfulness in the type signature
effect_demo! : Str => Result {} [StdoutErr _, StdoutLineFailed [StdoutErr _]]
effect_demo! = |msg|

    # `?` to return the error if there is one
    Stdout.line!(msg)?

    # ` ? ` for map_err
    Stdout.line!(msg) ? |err| StdoutLineFailed(err)
    # this also works:
    Stdout.line!(msg) ? StdoutLineFailed

    # ?? to provide default value
    Stdout.line!(msg) ?? {}

    # In rare cases, you can use `_ =` to ignore the result.
    # This allows you to avoid StdoutErr in the type signature.
    # Example of appropriate usage:
    # https://github.com/roc-lang/basic-webserver/blob/main/platform/main.roc
    _ = Stdout.line!(msg)

    Ok({})

dbg_expect : {} -> {}
dbg_expect = |{}|
    a = 42

    dbg a

    # dbg can forward what it receives
    b = dbg 43

    # inline expects get removed in optimized builds!
    expect b == 43

    {}

# Top level expect
expect 0 == 0

# Values that are defined inside a multi-line expect get printed on failure
expect
    expected = 43
    actual = 44
    
    actual == expected

if_demo : U64 -> Str
if_demo = |num|
    # every if must have an else branch!
    one_line_if = if num == 1 then "True" else "False"

    # multiline if
    if num == 2 then
        one_line_if
    else if num == 3 then
        "False"
    else
        "False"

tuple_demo : {} -> (Str, U32)
tuple_demo = |{}|
    # tuples can contain multiple types
    # they are allocated on the stack
    ("Roc", 1)

tag_union_demo : Str -> [Red, Green, Yellow]
tag_union_demo = |string|
    when string is
        "red" -> Red
        "green" -> Green
        # We can't list all possible strings, so we use `_` to match all other cases.
        _ -> Yellow

type_var_star : List * -> List _
type_var_star = |lst| lst

TypeWithTypeVar a : [
    TagOne,
    TagTwo Str,
]a

tag_union_advanced : Str -> TypeWithTypeVar [TagThree, TagFour U64]
tag_union_advanced = |string|
    when string is
        "one" -> TagOne
        "two" -> TagTwo("hello")
        "three" -> TagThree
        # We can't list all possible strings, so we use `_` to match all other cases.
        _ -> TagFour(42)

default_val_record : { a ?? Str } -> Str
default_val_record = |{ a ?? "default" }|
    a

destructuring =
    tup = ("Roc", 1)
    (str, num) = tup

    rec = { x: 1, y: tup.1 } # tuple access with `.index`
    { x, y } = rec

    (str, num, x, y)

record_update =
    rec = { x: 1, y: 2 }
    rec2 = { rec & y: 3 }
    rec2

record_access_func = .x

# You can pass a record with many more fields than just x and y.
open_record_arg_sum : { x: U64, y: U64 }* -> U64
open_record_arg_sum = |{ x, y }|
    x + y

number_literals =
    usage_based = 5
    explicit_u8 = 5u8
    explicit_i8 = 5i8
    explicit_u16 = 5u16
    explicit_i16 = 5i16
    explicit_u32 = 5u32
    explicit_i32 = 5i32
    explicit_u64 = 5u64
    explicit_i64 = 5i64
    explicit_u128 = 5u128
    explicit_i128 = 5i128
    explicit_f32 = 5.0f32
    explicit_f64 = 5.0f64
    explicit_dec = 5.0dec

    hex = 0x5
    octal = 0o5
    binary = 0b0101
    
    (usage_based, explicit_u8, explicit_i8, explicit_u16, explicit_i16, explicit_u32, explicit_i32, explicit_u64, explicit_i64, explicit_u128, explicit_i128, explicit_f32, explicit_f64, explicit_dec, hex, octal, binary)

# Using `where` ... `implements`
to_str : a -> Str where a implements Inspect
to_str = |value|
    Inspect.to_str(value)

# Opaque type
Username := Str

username_from_str : Str -> Username
username_from_str = |str|
    @Username(str)

username_to_str : Username -> Str
username_to_str = |@Username(str)|
    str

# Opaque type with derived abilities
StatsDB := Dict Str { score : Dec, average : Dec } implements [ Eq, Hash ]

# Custom implementation of an ability
Animal := [
        Dog Str,
        Cat Str,
    ]
    implements [
        Eq { is_eq: animal_equality },
    ]

animal_equality : Animal, Animal -> Bool
animal_equality = |@Animal(a), @Animal(b)|
    when (a, b) is
        (Dog(name_a), Dog(name_b)) | (Cat(name_a), Cat(name_b)) -> name_a == name_b
        _ -> Bool.false

# Defining a new ability
CustomInspect implements
    inspect_me : val -> Str where val implements CustomInspect

Color := [Red, Green]
    implements [
        Eq,
        CustomInspect {
            inspect_me: inspect_color,
        },
    ]

inspect_color : Color -> Str
inspect_color = \@Color color ->
    when color is
        Red -> "Red"
        Green -> "Green"

early_return = |arg|
    first =
        if !arg then
            return 99
        else
            "continue"

    # Do some other stuff
    Str.count_utf8_bytes(first)


record_builder_example =
    parser = { chain <-
        name: parse(Ok),
        age: parse(Str.to_u32),
        city: parse(Ok),
    } |> run
    
    parser("Alice-25-NYC")

# record builder helpers

Builder a := List Str -> Result (a, List Str) [Empty]

parse : (Str -> Result a [Empty]) -> Builder a
parse = |f| @Builder |segments|
    when segments is
        [] -> Err(Empty)
        [first, .. as rest] -> 
            when f(first) is
                Ok(value) -> Ok((value, rest))
                Err(_) -> Err(Empty)

chain : Builder a, Builder b, (a, b -> c) -> Builder c
chain = |@Builder(fa), @Builder(fb), combine|
    @Builder |segments|
        (a, rest1) = fa(segments)?
        (b, rest2) = fb(rest1)?
        Ok((combine(a, b), rest2))

run : Builder a -> (Str -> Result a [Empty])
run = |@Builder(f)| |input|
    segments = Str.split_on(input, "-")
    (result, _) = f(segments)?
    Ok(result)

# end record builder helpers


main! : List Arg => Result {} _
main! = |_args|
    Stdout.line!("${Inspect.to_str(number_operators(10, 5))}")?
    Stdout.line!("${Inspect.to_str(boolean_operators(Bool.true, Bool.false))}")?

    pizza_out = pizza_operator("Pizza ", "Roc")
    Stdout.line!("${Inspect.to_str(pizza_out)}")?
    StdoutAlias.line!("${Inspect.to_str(patterns([1, 2, 3, 4]))}")?
    Stdout.line!("${string_stuff}")?
    Stdout.line!("${Inspect.to_str(pattern_match_tag_union(Ok({})))}")?
    Stdout.line!("${Inspect.to_str(effect_demo!("Hello, world!"))}")?
    Stdout.line!("${Inspect.to_str(if_demo(1))}")?
    Stdout.line!("${Inspect.to_str(tuple_demo({}))}")?
    Stdout.line!("${Inspect.to_str(tag_union_demo("red"))}")?
    Stdout.line!("${Inspect.to_str(type_var_star([1, 2]))}")?
    Stdout.line!("${Inspect.to_str(tag_union_advanced("four"))}")?
    Stdout.line!("${default_val_record({})}")?
    Stdout.line!("${Inspect.to_str(destructuring)}")?
    Stdout.line!("${Inspect.to_str(record_update)}")?
    Stdout.line!("${Inspect.to_str(record_access_func({ x: 44, y: 3 }))}")?
    Stdout.line!("${Inspect.to_str(dbg_expect({}))}")?
    Stdout.line!("${Num.to_str(open_record_arg_sum({ x: 1, y: 3 }))}")?
    Stdout.line!("${Inspect.to_str(number_literals)}")?
    Stdout.line!("${username_to_str(username_from_str("Rocco"))}")?
    Stdout.line!("${to_str(42)}")?
    Stdout.line!("${Inspect.to_str(early_return(Bool.false))}")?
    Stdout.line!("${Inspect.to_str(record_builder_example)}")?
    Stdout.line!("${Inspect.to_str(Str.count_utf8_bytes(readme) > 0)}")?

    # Commented out so CI tests can pass
    # crash "Avoid using crash in production software!"

    Ok({})

