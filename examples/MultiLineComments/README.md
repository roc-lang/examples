# Multi-line comments

Roc does not support native multi-line comments like `/*...*/` in other languages (see below for why).
It's `#` all the way:

```roc
# Line 1
# Line 2
# Line 3
```

**TIP:** Many editors provide shortcuts to (un)comment multiple lines at once, like `Ctrl`+`/` in vscode.

## Why?

We need to use `#` for compatibility with unix [shebangs](https://en.wikipedia.org/wiki/Shebang_%28Unix%29). This allows roc files to be run as a script with for example `./myscript.roc`.