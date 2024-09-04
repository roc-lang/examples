# Importing a Package from a Module

You probably know how to use a package in an app, for example with the unicode package:
```roc
file:main.roc:snippet:header
```

But how can you use a package in a module?
All dependencies go in the app file!

So we have the app file just like before:
```roc
file:main.roc
```
And we put the unicode import in the module:
```roc
file:Module.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
(Ok ["h", "e", "l", "l", "o"])
```
