# Authoring a Platform

This example creates a small platform that embeds a Roc function in a host program. Three versions of the host—in C, Zig, and Rust—use the same Roc app and platform contract, so you can compare the languages without having to learn a different example each time.

The host calls a Roc function with `41` and prints the result, `42`. The examples include build commands for macOS, Linux, and Windows x64.

## The shared Roc code

The platform’s entry point describes the connection between the app and its host:

```roc
file:platform/main.roc
```

Three parts of the header establish that connection:

- `requires` asks the app for a `transform` function with the specified type.
- `provides` exports a platform-local wrapper under the symbol `roc_transform`. All three host languages call it using the C ABI.
- `targets` selects a static archive containing the compiled app and Roc builtins. The host’s toolchain links that archive into the final executable.

The app supplies `transform`, which simply adds one to its argument:

```roc
file:main.roc
```

From this directory, first build the Roc archive. On macOS or Linux:

```sh
roc build main.roc --output=app.a
```

On Windows, the archive uses the MSVC ABI and a `.lib` extension:

```powershell
roc build main.roc --target=x64win --output=app.lib
```

You can then choose any of the hosts below. The examples use C11, Zig 0.17.0, and Rust 1.98.1 with the 2024 edition. On Windows, the commands assume an x64 Visual Studio Developer PowerShell with the C++ build tools and Windows SDK installed; the Rust toolchain should be `x86_64-pc-windows-msvc`.

## C host

The C host declares `roc_transform` as an external function. It also supplies the runtime callbacks for memory allocation, debugging, and failure reporting:

```c
file:host.c
```

On Linux, build and run it with:

```sh
cc -std=c11 host.c app.a -lm -no-pie -o host-c
./host-c
```

The pinned Roc compiler produces a static archive containing code that is not
position-independent. Ubuntu and some other Linux distributions default to
position-independent executables (PIE), so `-no-pie` is needed when linking this
archive. On macOS, use the same command without `-no-pie`.

On Windows, use the Visual Studio C compiler:

```powershell
cl /nologo /std:c11 host.c app.lib /Fe:host-c.exe
.\host-c.exe
```

## Zig host

Zig’s `extern` declaration imports the Roc entry point, while `export fn` makes the runtime callbacks available to Roc. This small host uses libc for allocation and reallocation, so both operations use the same allocator:

```zig
file:host.zig
```

On Linux:

```sh
zig build-exe host.zig app.a -lc -fno-PIE -femit-bin=host-zig
./host-zig
```

On macOS, omit `-fno-PIE`.

On Windows, select the MSVC ABI to match the Roc archive:

```powershell
zig build-exe host.zig app.lib -lc -target x86_64-windows-msvc -femit-bin=host-zig.exe
.\host-zig.exe
```

## Rust host

Rust calls the Roc entry point through `unsafe extern "C"`. The callbacks use `#[unsafe(no_mangle)]` to retain the symbol names Roc expects. As in the other hosts, allocations and reallocations go through libc:

```rust
file:host.rs
```

On Linux:

```sh
rustc --edition=2024 host.rs -C link-arg=app.a -C relocation-model=static -o host-rust
./host-rust
```

On macOS, omit `-C relocation-model=static`.

On Windows:

```powershell
rustc --edition=2024 host.rs -C link-arg=app.lib -o host-rust.exe
.\host-rust.exe
```

Each host should print `42` and exit successfully. You can also run `roc test main.roc` to test the Roc function separately.

## Testing and extending the platform

From the repository root, `python ci_scripts/test_platform_authoring.py` builds and runs all three hosts. The regular examples test script continues to check the C host on every PR without requiring Zig or Rust to be installed.

This example keeps the boundary small by passing only integers. Its allocator wrappers accept alignments up to eight bytes, which is sufficient for this `I64` example. A general-purpose platform would need to support larger alignments too, as well as ownership transfers when passing strings, lists, or other allocated values across the boundary.

A larger platform might expose type modules and provide effects implemented by the host, declared in a `hosted` section. [Roc’s platform documentation](https://www.roc-lang.org/docs/main/langref/platforms/) explains how these pieces fit together.

For a more complete starting point, [Luke Boswell](https://github.com/lukewilliamboswell) maintains platform templates for several host languages and environments:

- [Rust](https://github.com/lukewilliamboswell/roc-platform-template-rust)
- [Zig](https://github.com/lukewilliamboswell/roc-platform-template-zig)
- [Go](https://github.com/lukewilliamboswell/roc-platform-template-go)
- [C](https://github.com/lukewilliamboswell/roc-platform-template-c)
- [WASI](https://github.com/lukewilliamboswell/roc-platform-template-wasi)
- [Swift](https://github.com/lukewilliamboswell/roc-platform-template-swift)

Each template has its own toolchain requirements and supported targets, so its README is the best place to start when choosing one.

During development, the app refers to the platform by its local path. To distribute a platform with its host included, you would provide compiled host inputs for each supported target, bundle it with `roc bundle platform/main.roc`, and publish the archive. Consumers could then select the platform using its full release URL.
