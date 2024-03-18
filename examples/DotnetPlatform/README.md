# DotNet platform example

How to run it:

1. Build the roc app that is using the dotnet platform under the root:

```cli
roc build main.roc --lib --output ./platform/interop
```
> _use `arch -arm64` if you are running in a Apple Silicon mac._

This will produce a shared library file that we'll be able to import from a .NET context.

2. `cd` into the `platform` folder and run:
```cli
dotnet run
```
This should print the message under the `roc.main` file bound to the expression named `main`.

If you want to build the app using native AOT:

1. Publish the dotnet app
```cli
dotnet publish -c Release
```
> _use `arch -arm64` if you are running in a Apple Silicon mac._

2. `cd` into the into the `publish` folder and run the binary:
```cli
./DotNetRocPlatform
```
