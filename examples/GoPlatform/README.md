# Go Platform

A minimal go platform.

## Full Code

main.roc:
```roc
file:main.roc
```

platform/main.roc:
```
file:platform/main.roc
```

platform/go.mod:
```
file:platform/go.mod
```

platform/main.go:
```go
file:platform/main.go
```

platform/host.h:
```
file:platform/host.h
```

## Build Instructions

The Roc compiler can't build a go platform by itself. [In the
future](https://roc.zulipchat.com/#narrow/stream/304641-ideas/topic/Platform.20host.20build.20process) there will be a way for a platform to define the build process.
For now, the compiled Roc binary and the go binary have to be manualy [linked](https://en.wikipedia.org/wiki/Linker_(computing)).

Build steps:

```bash
cd examples/GoPlatform
roc build --no-link main.roc
go build platform/main.go
```

Run the produced executable with `./main`.
