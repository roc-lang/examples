# Web App with Elm

A minimal web app with an Elm frontend and Roc backend. The Roc backend uses the [basic-webserver](https://github.com/roc-lang/basic-webserver) platform.

## Why Elm + Roc?

Roc was inspired by Elm, so it's nice to be able to use a similar language for the frontend. Elm also has a mature collection of re-usable packages.

## Alternatives

We've also enjoyed using [htmx with Roc](https://github.com/lukewilliamboswell/roc-htmx-playground). It allows you to use Roc for the frontend and the backend.

## Full Code 

src/Main.elm:
```elm
file:frontend/src/Main.elm
```

elm.json:
```json
file:frontend/elm.json
```

index.html:
```html
file:frontend/index.html
```

backend.roc:
```roc
file:backend.roc
```
## Running

### Roc

The Roc server runs on port 8000. You can change that in `init!` with `Server.default_config.with_listen({ host: "127.0.0.1", port: 8000 })`. If you do, also update the url in `Main.elm`.

```bash
cd examples/ElmWebApp/

# development
roc backend.roc

# production
roc build --opt=speed backend.roc
./backend
```

### Elm

This example uses [Elm 0.19.3](https://guide.elm-lang.org/install/elm.html).

> Note 1: for non-trivial Elm development we recommend using [elm-watch](https://github.com/lydell/elm-watch).

> Note 2: if you have npx installed, you can do `npx elm make ...` to avoid needing to install elm.

Compile elm code to javascript:

```bash
cd examples/ElmWebApp/frontend
# development
elm make src/Main.elm --output elm.js
# production
elm make src/Main.elm --output elm.js --optimize
```

Serve the frontend:

```bash
# Roc backend will be on 8000
elm reactor --port 8001
```

For production; use a battle-tested HTTP server instead of `elm reactor`.

Open [http://localhost:8001/index.html](http://localhost:8001/index.html) in your browser.
Use `localhost` rather than `127.0.0.1`: the Roc backend only allows requests from the origin `http://localhost:8001`.
