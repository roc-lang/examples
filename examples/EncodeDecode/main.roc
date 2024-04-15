app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.9.0/oKWkaruh2zXxin_xfsYsCJobH1tO8_JvNkFzDwwzNUQ.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.7.0/xuaMzXRVG_SEhOFZucS3iBozlRdObWsfKaYZMHVE_q0.tar.br",
    }
    imports [
        pf.Stdout.{ line },
        json.Core.{ json },
        Decode.{ Decoder, DecoderFormatting, DecodeResult, DecodeError },
        Encode.{ Encoder, EncoderFormatting },
    ]
    provides [main] to pf

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
        Decoding { decoder: decodeItems },
        Encoding { toEncoder: encodeItems },
        Inspect,
        Eq,
    ]

tryMapResult : DecodeResult U32, (U32 -> Result ItemKind DecodeError) -> DecodeResult ItemKind
tryMapResult = \decoded, mapper ->
    when decoded.result is
        Err e -> { result: Err e, rest: decoded.rest }
        Ok res -> { result: mapper res, rest: decoded.rest }

decodeItems : Decoder ItemKind fmt where fmt implements DecoderFormatting
decodeItems = Decode.custom \bytes, fmt ->
    # Helper function to wrap our tag
    ok = \tag -> Ok (@ItemKind tag)

    bytes
    |> Decode.fromBytesPartial fmt
    |> tryMapResult \val ->
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

encodeItems : ItemKind -> Encoder fmt where fmt implements EncoderFormatting
encodeItems = \@ItemKind val ->
    num =
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
    Encode.u32 num

### end snippet impl

### start snippet demo

# make a list of ItemKind's
originalList : List ItemKind
originalList = [
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
encodedBytes : List U8
encodedBytes = Encode.toBytes originalList json

# test we have encoded correctly
expect encodedBytes == originalBytes

# take a JSON encoded list
originalBytes : List U8
originalBytes = "[1,2,3,4,5,6,7,8,9,10]" |> Str.toUtf8

# decode into a list of ItemKind's
decodedList : List ItemKind
decodedList = Decode.fromBytes originalBytes json |> Result.withDefault []

# test we have decoded correctly
expect decodedList == originalList

main =
    # debug print decoded items to stdio
    decodedList
    |> List.map Inspect.toStr
    |> Str.joinWith "\n"
    |> Stdout.line

### end snippet demo
