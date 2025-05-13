app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.12.0/1trwx8sltQ-e9Y2rOB4LWUWLS_sFVyETK8Twl0i9qpw.tar.gz",
}

import json.Json
import cli.Stdout
import cli.Arg exposing [Arg]
### start snippet impl

ItemKind := [
    Text,
    Method,
    Function,
    Constructor,
    Field,
    Variable,
    Class,
    Interface,
    Module,
    Property,
]
    implements [
        Decoding { decoder: decode_items },
        Encoding { to_encoder: encode_items },
        Inspect,
        Eq,
    ]

encode_items : ItemKind -> Encoder fmt where fmt implements EncoderFormatting
encode_items = |@ItemKind(kind)|
    Encode.u32(
        when kind is
            Text -> 1
            Method -> 2
            Function -> 3
            Constructor -> 4
            Field -> 5
            Variable -> 6
            Class -> 7
            Interface -> 8
            Module -> 9
            Property -> 10,
    )

decode_items : Decoder ItemKind _
decode_items =
    Decode.custom(
        |bytes, fmt|
            # Helper function to wrap our [tag](https://www.roc-lang.org/tutorial#tags)
            ok = |tag| Ok(@ItemKind(tag))

            bytes
            |> Decode.from_bytes_partial(fmt)
            |> try_map_result(
                |num|
                    when num is
                        1 -> ok(Text)
                        2 -> ok(Method)
                        3 -> ok(Function)
                        4 -> ok(Constructor)
                        5 -> ok(Field)
                        6 -> ok(Variable)
                        7 -> ok(Class)
                        8 -> ok(Interface)
                        9 -> ok(Module)
                        10 -> ok(Property)
                        _ -> Err(TooShort),
            ),
    )

# Converts `DecodeResult U32` to `DecodeResult ItemKind` using a given function
try_map_result : DecodeResult U32, (U32 -> Result ItemKind DecodeError) -> DecodeResult ItemKind
try_map_result = |decoded, num_to_item_kind_fun|
    when decoded.result is
        Err(e) -> { result: Err(e), rest: decoded.rest }
        Ok(res) -> { result: num_to_item_kind_fun(res), rest: decoded.rest }

### end snippet impl

### start snippet demo

# make a list of ItemKind's
original_list : List ItemKind
original_list = [
    @ItemKind(Text),
    @ItemKind(Method),
    @ItemKind(Function),
    @ItemKind(Constructor),
    @ItemKind(Field),
    @ItemKind(Variable),
    @ItemKind(Class),
    @ItemKind(Interface),
    @ItemKind(Module),
    @ItemKind(Property),
]

# encode them into JSON bytes
encoded_bytes : List U8
encoded_bytes = Encode.to_bytes(original_list, Json.utf8)

# check that encoding is correct
expect
    expected_bytes : List U8
    expected_bytes = "[1,2,3,4,5,6,7,8,9,10]" |> Str.to_utf8

    encoded_bytes == expected_bytes

# decode back to a list of ItemKind's
decoded_list : List ItemKind
decoded_list = Decode.from_bytes(encoded_bytes, Json.utf8) |> Result.with_default([])
# don't use `Result.with_default([])` for professional applications; check https://www.roc-lang.org/examples/ErrorHandling/README.html

# check that decoding is correct
expect decoded_list == original_list

main! : List Arg => Result {} _
main! = |_args|
    # prints decoded items to stdout
    decoded_list
    |> List.map(Inspect.to_str)
    |> Str.join_with("\n")
    |> Stdout.line!

### end snippet demo
