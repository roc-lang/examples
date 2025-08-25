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

You can change the port on which the Roc server runs with ROC_BASIC_WEBSERVER_PORT.
```
cd examples/ElmWebApp/

# development
roc backend.roc --linker=legacy

# production
roc build backend.roc --optimize --linker=legacy
./backend
```

### Elm

> Note: for non-trivial Elm development we recommend using [elm-watch](https://github.com/lydell/elm-watch).

Compile elm code to javascript:
```
cd examples/ElmWebApp/frontend
# development
elm make src/Main.elm --output elm.js
# production
elm make src/Main.elm --output elm.js --optimize
```

Serve the frontend:
```
elm reactor --port 8001 # Roc backend will be on 8000
```
For production; use a battle-tested HTTP server instead of elm reactor.

Open [localhost:8001/index.html](localhost:8001/index.html) in your browser.
