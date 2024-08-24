app [Model, server] {
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.8.0/jz2EfGAtz_y06nN7f8tU9AvmzhKK-jnluXQQGa9rZoQ.tar.br"
}

import pf.Stdout
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Utc

# [backend](https://chatgpt.com/share/7ac35a32-dab5-46d0-bb17-9d584469556f) Roc server

# Model is produced by `init`.
Model : {}

# With `init` you can set up a database connection once at server startup,
# generate css by running `tailwindcss`,...
# In this case we don't have anything to initialize, so it is just `Task.ok {}`.

server = { init: Task.ok {}, respond }

respond : Request, Model -> Task Response [ServerErr Str]_
respond = \req, _ ->
    # Log request datetime, method and url
    datetime = Utc.now! |> Utc.toIso8601Str

    Stdout.line! "$(datetime) $(Http.methodToStr req.method) $(req.url)"

    Task.ok {
        status: 200,
        headers: [
            # !!
            # Change http://localhost:8001 to your domain for production usage
            # !!
            { name: "Access-Control-Allow-Origin", value: "http://localhost:8001" },
        ],
        body: Str.toUtf8 "Hi, Elm! This is from Roc: 🎁\n",
    }
