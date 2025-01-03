app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.11.0/z45Wzc-J39TLNweQUoLw3IGZtkQiEN3lTBv3BXErRjQ.tar.br",
}

import cli.Stdout
import json.Json

main! = \_args ->
    request_body = Str.toUtf8 "{\"Image\":{\"Animated\":false,\"Height\":600,\"Ids\":[116,943,234,38793],\"Thumbnail\":{\"Height\":125,\"Url\":\"http:\\/\\/www.example.com\\/image\\/481989943\",\"Width\":100},\"Title\":\"View from 15th Floor\",\"Width\":800}}"

    # This { fieldNameMapping: PascalCase } setting translates
    # incoming JSON fields from PascalCase (first letter capitalized)
    # to camelCase (first letter uncapitalized), which is what
    # Roc field names always use.
    decoder = Json.utf8With { fieldNameMapping: PascalCase }

    decoded : DecodeResult ImageRequest
    decoded = Decode.fromBytesPartial request_body decoder

    when decoded.result is
        Ok record -> Stdout.line! "Successfully decoded image, title:\"$(record.image.title)\""
        Err _ -> Err (Exit 1 "Error, failed to decode image")

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
