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

The Roc compiler can't build a go platform by itself so we have to execute some commands manually. [In the future](https://github.com/roc-lang/roc/issues/6414) there will be a standardized way for a platform to define the build process.

1. Let's make sure we're in the right directory:
```bash
$ cd examples/GoPlatform
```

2. We turn our Roc app into a library so go can use it:
```bash
$ roc build --lib main.roc --output platform/libapp.so
```

3. We build a go package using the platform directory. `pie` is used to create a [Position Independent Executable](https://en.wikipedia.org/wiki/Position-independent_code). Roc expects a file called dynhost so that's what we'll provide.
```bash
$ go build -C platform -buildmode=pie -o dynhost
```

4. We use the subcommand `preprocess-host` to make the surgical linker preprocessor generate `.rh` and `.rm` files.
```bash
$ roc preprocess-host platform/dynhost platform/main.roc platform/libapp.so
```

5. With our platform built we can run our app:
```bash
$ roc main.roc
```


## Publish the platform

1. Make sure you've [built the platform first](#build-instructions).

2. We'll create a compressed archive of our platform so anyone can use it easily. You can use `tar.br` for maximal compression or `tar.gz` if you're in a hurry:
```bash
$ roc build --bundle .tar.br platform/main.roc
```

3. Put the created `tar.br` on a server. You can use github releases like we do with [basic-cli](https://github.com/roc-lang/basic-cli/releases).

4. Now you can use the platform from inside a Roc file with:
```roc
app [main] { pf: platform "YOUR_URL" }
```

‼ This build procedure only builds the platform for your kind of operating system and architecture. If you want to support users on all Roc supported operating systems and architectures, you'll need [this kind of setup](https://github.com/roc-lang/roc/blob/main/.github/workflows/basic_cli_build_release.yml).
