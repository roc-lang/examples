app [Context, program] {
	http: "https://github.com/roc-lang/http/releases/download/2.0.0/6ZUwqYhCS8PU9Mo6MF7oV82ET2o7KYb57CLKDq4cq4sS.tar.zst",
	pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.17.0/AC9goxhsjJJdrQtnc2ga3eTiESyh6ZLraZJsCVdEfeZT.tar.zst",
}

import pf.Server
import http.Response

Context : {}

program = { init!, respond!, shutdown! }

# With `init` you can set up a database connection once at server startup,
# generate css by running `tailwindcss`...
# In this case we don't have anything to initialize, so we use the default
# config.
init! : () => Try({ config : Server.Config, context : Context }, [Exit(I64)])
init! = || Ok({ config: Server.default_config, context: {} })

respond! : Server.Request, Context => Try(Server.Outcome, [ServerErr(Str)])
respond! = |_request, _context|
	Ok(
		Server.respond(
			Response.from_status(200)
				.with_headers([{ name: "Content-Type", value: "text/html; charset=utf-8" }])
				.with_body(Str.to_utf8("<b>Hello from Roc!</b>")),
		),
	)

shutdown! : Server.ShutdownReason, Context => Try({}, [Exit(I64)])
shutdown! = |_reason, _context| Ok({})
