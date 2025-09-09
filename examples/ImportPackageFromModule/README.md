# Importing a Package from a Module

You probably know how to add a package in an app file, for example with the unicode package:
```roc
file:main.roc:snippet:header
```

But how can you add a package inside a module file?
All dependencies go in the app file!

So we have the app file just like before:
```roc
file:main.roc
```
And the unicode import goes in the module file:
```roc
file:Module.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
(Ok ["h", "e", "l", "l", "o"])
```
