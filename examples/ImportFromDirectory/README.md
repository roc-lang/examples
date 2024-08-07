# Import from Directory

To import a module that lives inside a Directory:
```roc
import Dir.Hello exposing [hello]
```

You can also do:
```roc
import Dir.Hello as Hello
```
Or:
```roc
import Dir.Hello
```
Note that in this last case you will need to use `Dir.Hello` in your code, for example: `Dir.Hello.hello "World!"`.

## Code

Dir/Hello.roc:

```roc
file:Dir/Hello.roc
```

main.roc:

```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
Hello World from inside Dir!
```
