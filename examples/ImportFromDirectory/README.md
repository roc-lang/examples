# Import from Directory

To import a module that lives inside a Directory:
```roc
import Dir.Hello exposing [hello]
```

You can also do:
```roc
import Dir/Hello as Hello
```
Note that in this case you will need to use `Hello.hello` in your code (not just `hello`), for example: `Hello.hello("World!")`.

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
Hello World from inside Dir.Hello module!
```
