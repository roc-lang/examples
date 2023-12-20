# Interface Modules

Interface modules are useful to organise the code of your application into different files in the same codebase with their own namespace. This is useful for large applications, or for libraries that you want to split into multiple files. 

## Code

main.roc

```roc
file:main.roc
```

Hello.roc

```roc
file:Hello.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc run
Hello World from interface!
```
