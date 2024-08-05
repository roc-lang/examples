app [main] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.13.0/nW9yMRtZuCYf1Oa9vbE5XoirMwzLbtoSgv7NGhUlqYA.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.8.0/BlWJJh_ouV7c_IwvecYpgpR3jOCzVO-oyk-7ISdl2S4.tar.br",
}

import cli.Stdout
import cli.Task
import json.Core exposing [jsonWithOptions]
import Decode exposing [fromBytesPartial]

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
