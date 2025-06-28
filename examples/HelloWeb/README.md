# Hello Web

A webserver that serves one web page showing `Hello, web!` using the [basic-webserver platform](https://github.com/roc-lang/basic-webserver).

There are much more [basic-webserver examples](https://github.com/roc-lang/basic-webserver/tree/main/examples).

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it and go to http://localhost:8000/ in your browser:

```
$ roc main.roc --linker=legacy
Listening on http://127.0.0.1:8000
```

- Change the port (8000); e.g `export ROC_BASIC_WEBSERVER_PORT=8888`
- Change the host (localhost); e.g. `export ROC_BASIC_WEBSERVER_HOST=0.0.0.0`
- Change the number of threads; e.g. `export TOKIO_WORKER_THREADS=4`

Optimized build:
```
$ roc build --optimize main.roc --linker=legacy
```
