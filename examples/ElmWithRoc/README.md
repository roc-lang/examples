# Building a Roc Web Server with an Elm Frontend


## 1. Run Roc webserver

```
$ cd ElmWithRoc
````

Run this from the ElmWithRoc directory
```
$ roc run webserver.roc
````

## 2. Run Elm Frontend
--port <PORT_NUMBER>, should not be 8000
Check reason below

```
$ cd frontend
$ elm reactor --port 8001
````

## Setting a custom port throug environment variables

By default a roc webserver listens on port 8000
You can tell the webserver to listen on a different port by setting an environment variable

Remember to change the port the Elm Frontend is sending the request to, if you change the port
the Roc webserver is listening on. Check frontend/src/Main.elm line 76

```
$ export ROC_BASIC_WEBSERVER_PORT=8080
````
