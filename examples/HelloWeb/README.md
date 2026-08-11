# Hello Web

A webserver that serves one web page showing `Hello from Roc!` using the [basic-webserver platform](https://github.com/roc-lang/basic-webserver).

There are much more [basic-webserver examples](https://github.com/roc-lang/basic-webserver/tree/main/examples).

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it and go to http://localhost:8000/ in your browser:

```
$ roc main.roc
Listening on http://127.0.0.1:8000
```

On Linux or macOS:

- To change the port: `export ROC_BASIC_WEBSERVER_PORT=8888`
- To change the host: `export ROC_BASIC_WEBSERVER_HOST=0.0.0.0`
- To change the number of threads: `export TOKIO_WORKER_THREADS=4`

On Windows, replace `export xxx=yyy` with `set xxx=yyy` (or `$env:xxx=yyy` in the Powershell).

To optimize build:
```
$ roc build --opt=speed --output=hello-web main.roc
$ ./hello-web
```
