
# Basic Json Example

This application uses the `roc-lang/basic-cli` platform and a Json package to demonstrate how Roc can serialise and de-serialise data using the `Encode` and `Decode` abilities and a custom Json implementation.

You can run this example with `roc run main.roc`.

```roc
main.roc
```

## Secondary Notes 

**URL Packages.** Both the imported platform and package are downloaded from a URL. Roc will download these as a tarball if they are not already present in the cache, confirm the contents match the file hash, and then build the application.

**Roc Scripts.** Also this example demonstrates how Roc applications can be used as scripts. The file starts with a `#!/usr/bin/env roc` which tells the operating system on UNIX and MacOS to run this file as a script. This can then be done with the command `./hello-json.roc`. Note that you may need to make the file executable using `chmod 755 hello-json.roc`

