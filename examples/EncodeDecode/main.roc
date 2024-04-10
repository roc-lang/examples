app "example"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.6.3/_2Dh4Eju2v_tFtZeMq8aZ9qw2outG04NbkmKpFhXS_4.tar.br",
    }
    imports [pf.Stdout.{ line }, json.Core.{ json }]
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
]
    implements [
        Decoding { decoder: decodeItems },
        Encoding { toEncoder: encodeItems },
        Inspect,
        Eq,
    ]

decodeItems : Decoder ItemKind fmt
decodeItems = Decode.custom \bytes, _ ->

    # helper to convert our tag to a DecodeResult
    ok : _, List U8 -> DecodeResult ItemKind
    ok = \tag, rest -> { result: Ok (@ItemKind tag), rest }

    when bytes is
        ['1', .. as rest] -> ok Text rest
        ['2', .. as rest] -> ok Method rest
        ['3', .. as rest] -> ok Function rest
        ['4', .. as rest] -> ok Constructor rest
        ['5', .. as rest] -> ok Field rest
        ['6', .. as rest] -> ok Variable rest
        ['7', .. as rest] -> ok Class rest
        ['8', .. as rest] -> ok Interface rest
        ['9', .. as rest] -> ok Module rest
        _ -> { result: Err TooShort, rest: bytes }

encodeItems : ItemKind -> Encoder fmt
encodeItems = \@ItemKind tag ->

    Encode.custom \bytes, _ ->

        # helper to append our encoded byte
        append : U8 -> List U8
        append = \u8 -> List.append bytes u8

        when tag is
            Text -> append '1'
            Method -> append '2'
            Function -> append '3'
            Constructor -> append '4'
            Field -> append '5'
            Variable -> append '6'
            Class -> append '7'
            Interface -> append '8'
            Module -> append '9'

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
]

# encode them into JSON
encodedBytes : List U8
encodedBytes = Encode.toBytes originalList json

# test we have encoded correctly
expect encodedBytes == originalBytes

# take a JSON encoded list
originalBytes : List U8
originalBytes = "[1,2,3,4,5,6,7,8,9]" |> Str.toUtf8

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
