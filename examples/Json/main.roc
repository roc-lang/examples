app "json-basic"
    packages {
        cli: "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
        json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.7.0/xuaMzXRVG_SEhOFZucS3iBozlRdObWsfKaYZMHVE_q0.tar.br",
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
        Ok record -> Stdout.line "Successfully decoded image, title:\"$(record.image.title)\""
        Err _ -> Task.err (Exit 1 "Error, failed to decode image")

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
