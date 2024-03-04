app "json-basic"
    packages {
        cli: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8URkvfyi9I0QhmVG98roKBUs_AZRkLFwFJVJ3942YA.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.6.3/_2Dh4Eju2v_tFtZeMq8aZ9qw2outG04NbkmKpFhXS_4.tar.br",
    }
    imports [
        cli.Stdout,
        cli.Task,
        json.Core.{ jsonWithOptions },
        Decode.{ DecodeResult, fromBytesPartial },
    ]
    provides [main] to cli

main =
    requestBody = Str.toUtf8 "{\"Image\":{\"Animated\":false,\"Height\":600,\"Ids\":[116,943,234,38793],\"Thumbnail\":{\"Height\":125,\"Url\":\"http:\\/\\/www.example.com\\/image\\/481989943\",\"Width\":100},\"Title\":\"View from 15th Floor\",\"Width\":800}}"

    # This { fieldNameMapping: PascalCase } setting translates
    # incoming JSON fields from PascalCase (first letter capitalized)
    # to camelCase (first letter uncapitalized), which is what
    # Roc field names always use.
    decoder = jsonWithOptions { fieldNameMapping: PascalCase }

    decoded : DecodeResult ImageRequest
    decoded = fromBytesPartial requestBody decoder

    when decoded.result is
        Ok record ->
            Stdout.line "Successfully decoded image, title:\"$(record.image.title)\""

        Err _ ->
            {} <- Stdout.line "Error, failed to decode image" |> Task.await

            Task.err 1 # 1 is an exit code to indicate failure

ImageRequest : {
    image : {
        width : I64,
        height : I64,
        title : Str,
        thumbnail : {
            url : Str,
            height : F32,
            width : F32,
        },
        animated : Bool,
        ids : List U32,
    },
}
