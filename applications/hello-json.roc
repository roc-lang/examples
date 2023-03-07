app "example"
    packages {
        cli: "https://github.com/roc-lang/basic-cli/releases/download/0.2.1/wx1N6qhU3kKva-4YqsVJde3fho34NqiLD3m620zZ-OI.tar.br",
        json: "../packages/json/main.roc",
    }
    imports [
        cli.Stdout,
        json.Core.{ Json, toUtf8, fromUtf8 },
        Decode,
    ]
    provides [main] to cli

main = Stdout.line "Hello \(person.name)!"

Person : {
    name : Str,
}

inputStr : Str
inputStr = "{\"name\":\"John Smith\"}"

person : Person
person =
    inputStr
    |> Str.toUtf8
    |> Decode.fromBytes fromUtf8
    |> Result.onErr \_ -> crash "bad decode"
    |> Result.withDefault { name: "" }

outputStr : Str
outputStr =
    person
    |> Encode.toBytes toUtf8
    |> Str.fromUtf8
    |> Result.onErr \_ -> crash "bad encode"
    |> Result.withDefault ""

expect outputStr == inputStr
