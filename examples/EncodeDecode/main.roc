app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.11.0/z45Wzc-J39TLNweQUoLw3IGZtkQiEN3lTBv3BXErRjQ.tar.br",
}

import json.Json
import pf.Stdout
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
        Encoding { toEncoder: encode_items },
        Inspect,
        Eq,
    ]

try_map_result : DecodeResult U32, (U32 -> Result ItemKind DecodeError) -> DecodeResult ItemKind
try_map_result = \decoded, mapper ->
    when decoded.result is
        Err e -> { result: Err e, rest: decoded.rest }
        Ok res -> { result: mapper res, rest: decoded.rest }

decode_items : Decoder ItemKind fmt where fmt implements DecoderFormatting
decode_items = Decode.custom \bytes, fmt ->
    # Helper function to wrap our tag
    ok = \tag -> Ok (@ItemKind tag)

    bytes
    |> Decode.fromBytesPartial fmt
    |> try_map_result \val ->
        when val is
            1 -> ok Text
            2 -> ok Method
            3 -> ok Function
            4 -> ok Constructor
            5 -> ok Field
            6 -> ok Variable
            7 -> ok Class
            8 -> ok Interface
            9 -> ok Module
            10 -> ok Property
            _ -> Err TooShort

encode_items : ItemKind -> Encoder fmt where fmt implements EncoderFormatting
encode_items = \@ItemKind val ->
    Encode.u32 (
        when val is
            Text -> 1
            Method -> 2
            Function -> 3
            Constructor -> 4
            Field -> 5
            Variable -> 6
            Class -> 7
            Interface -> 8
            Module -> 9
            Property -> 10
    )

### end snippet impl

### start snippet demo

# make a list of ItemKind's
original_list : List ItemKind
original_list = [
    @ItemKind Text,
    @ItemKind Method,
    @ItemKind Function,
    @ItemKind Constructor,
    @ItemKind Field,
    @ItemKind Variable,
    @ItemKind Class,
    @ItemKind Interface,
    @ItemKind Module,
    @ItemKind Property,
]

# encode them into JSON
encoded_bytes : List U8
encoded_bytes = Encode.toBytes original_list Json.utf8

# test we have encoded correctly
expect encoded_bytes == original_bytes

# take a JSON encoded list
original_bytes : List U8
original_bytes = "[1,2,3,4,5,6,7,8,9,10]" |> Str.toUtf8

# decode into a list of ItemKind's
decoded_list : List ItemKind
decoded_list = Decode.fromBytes original_bytes Json.utf8 |> Result.withDefault []

# test we have decoded correctly
expect decoded_list == original_list

main! = \_ ->
    # debug print decoded items to stdio
    decoded_list
    |> List.map Inspect.toStr
    |> Str.joinWith "\n"
    |> Stdout.line!

### end snippet demo
