# DotNet Platform 

A minimal .NET platform

## Full Code

main.roc:
```roc
file:main.roc
```

platform/main.roc:
```roc
file:platform/main.roc
```

platform/DotNetRocPlatform.csproj:
```xml
file:platform/DotNetRocPlatform.csproj
```

platform/Program.cs:
```csharp
file:platform/Program.cs
```

## Build & Run 

1. Build the roc app that is using the dotnet platform:

```cli
$ cd examples/DotNetPlatform/
$ roc build main.roc --lib --output ./platform/interop
```
> _use `arch -arm64` if you are running in a Apple Silicon mac._

This will produce a shared library file that we'll be able to import from a .NET context.

To run:
```cli
$ cd platform
$ dotnet run
```
This should print "Hello from .NET" and "Hi from roc! (in a .NET platform) 🔥🦅🔥".


## Build & Run Binary

To build a binary for the app using Ahead-Of-Time compilation:

1. Publish the dotnet app
```cli
$ dotnet publish -c Release
```
> _use `arch -arm64` if you are running in a Apple Silicon mac._

2. `cd` into the into the `publish` folder and run the binary:
```cli
$ ./DotNetRocPlatform
```
