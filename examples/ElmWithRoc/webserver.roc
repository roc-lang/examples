app [main] { pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.4.0/iAiYpbs5zdVB75golcg_YMtgexN3e2fwhsYPLPCeGzk.tar.br" }

import pf.Stdout
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Utc

main : Request -> Task Response []
main = \req ->
    # Log request datetime, method and url
    datetime = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(datetime) $(Http.methodToStr req.method) $(req.url)"
    Task.ok {
        status: 200,
        headers: [
            { name: "Access-Control-Allow-Origin", value: Str.toUtf8 "*" },
        ],
        body: Str.toUtf8 "Hello, world! This is Roc Picasso\n",
    }
