app [main] { pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.6.0/LQS_Avcf8ogi1SqwmnytRD4SMYiZ4UcRCZwmAjj1RNY.tar.gz" }

import pf.Stdout
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Utc

main : Request -> Task Response []
main = \req ->

    # Log request datetime, HTTP method and url
    datetime = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(datetime) $(Http.methodToStr req.method) $(req.url)"

    Task.ok { status: 200, headers: [], body: Str.toUtf8 "<b>Hello, world!</b>\n" }