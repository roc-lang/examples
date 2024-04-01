# Go Platform

A minimal go platform.

## Full Code

main.roc:
```roc
file:main.roc
```

platform/main.roc:
```roc
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
```c
file:platform/host.h
```

## Build Instructions

The Roc compiler can't build a go platform by itself. [In the
future](https://github.com/roc-lang/roc/issues/6414) there will be a way for a
platform to define the build process.

### Preprocess host

First, an example roc application has to be build as libary. Then the platform
has to be compiled to a file called `dynhost`. As last step, two files for the
surgical linker have to be generated.

This method uses [zig](https://ziglang.org/) as the c compiler used by go.

Build steps:
```
roc build --lib main.roc --output platform/libapp.so
CC="zig cc" go build -C platform -buildmode=pie -o dynhost
roc preprocess-host main.roc
```

To build and run the final binary, use: `roc run --prebuilt-platform`


### Publish the platform

To publish the platform, call: `roc build --bundle .tar.br platform/main.roc`.

The created `tar.br`-file can be published on a https-server. Afterwards, the
platform can be used from that server without the `--prebuilt-platform`
argument. roc uses `prebuilt-platform` automaticly, on non local platforms.
