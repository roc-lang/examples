app [Model, init!, respond!] { web: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.12.0/Q4h_In-sz1BqAvlpmCsBHhEJnn_YvfRRMiNACB_fBbk.tar.br" }

import web.Stdout
import web.Http exposing [Request, Response]
import web.Utc

# Model is produced by `init`.
Model : {}

# With `init` you can set up a database connection once at server startup,
# generate css by running `tailwindcss`,...
# In this case we don't have anything to initialize, so it is just `Ok({})`.

init! : {} => Result Model []
init! = |_| Ok({})

respond! : Request, Model => Result Response [ServerErr Str]_
respond! = |req, _|
    # Log request datetime, method and url
    datetime = Utc.to_iso_8601(Utc.now!({}))

    Stdout.line!("${datetime} ${Inspect.to_str(req.method)} ${req.uri}")?

    Ok(
        {
            status: 200,
            headers: [],
            body: Str.to_utf8("<b>Hello, web!</b></br>"),
        },
    )
