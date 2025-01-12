app [main!] {
    cli: platform "../../../basic-cli/platform/main.roc",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.12.0-testing/PfiXmq2sMeuYM_WZl4_-Dak5bbVkQ4SulTzFTDyiy1A.tar.gz",
}

import cli.Stdout
import json.Json

main! = \_args ->
    request_body = Str.to_utf8("{\"Image\":{\"Animated\":false,\"Height\":600,\"Ids\":[116,943,234,38793],\"Thumbnail\":{\"Height\":125,\"Url\":\"http:\\/\\/www.example.com\\/image\\/481989943\",\"Width\":100},\"Title\":\"View from 15th Floor\",\"Width\":800}}")

    # This { field_name_mapping: PascalCase } setting translates
    # incoming JSON fields from PascalCase (first letter capitalized)
    # to snake_case, which is what Roc field names always use.
    decoder = Json.utf8_with({ field_name_mapping: PascalCase })

    decoded : DecodeResult ImageRequest
    decoded = Decode.from_bytes_partial(request_body, decoder)

    when decoded.result is
        Ok(record) -> Stdout.line!("Successfully decoded image, title:\"${record.image.title}\"")
        Err(_) -> Err(Exit(1, "Error, failed to decode image"))

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
