# Hello Web

A webserver that serves one web page showing `Hello, world!` using the [basic-webserver platform](https://github.com/roc-lang/basic-webserver).

There are much more [basic-webserver examples](https://github.com/roc-lang/basic-webserver/tree/main/examples).

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it and go to http://localhost:8000/ in your browser:

```
$ roc main.roc --linker=legacy
Listening on <http://127.0.0.1:8000>
```

You can change the port (8000) and the host (localhost) by setting the environment variables `ROC_BASIC_WEBSERVER_PORT` and `ROC_BASIC_WEBSERVER_HOST`.