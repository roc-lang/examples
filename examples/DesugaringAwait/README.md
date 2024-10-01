# Desugaring !

<details>
  <summary>What's syntax sugar?</summary>
  
  Syntax within a programming language that is designed to make things easier 
  to read or express. It allows developers to write code in a more concise, readable, or
  convenient way without adding new functionality to the language itself.
</details>

Desugaring converts syntax sugar (like `x += 1`) into more fundamental operations (like `x = x + 1`).

Let's see how `!` is desugared, we'll start with a simple example:
```roc
file:main.roc:snippet:bang
```
After desugaring, this becomes:
```roc
file:main.roc:snippet:await
```
[Task.await](https://www.roc-lang.org/builtins/Task#await) takes the success value from a given
Task and uses that to generate a new Task.
It's type is `Task a b, (a -> Task c b) -> Task c b`.

The type of `Stdout.line` is `Str -> Task {} [StdoutErr Err]`.
Because `Stdout.line` does not return anything upon success, we use `\_` in the desugared version,
there is nothing to pass to the next Task.

You'll see that the version with `!` looks a lot simpler!

Note that for the last line in the first snippet `Stdout.line "Hello Bob"`, you could have also written
`Stdout.line! "Hello Bob"`. `!` is not necessary on the last line but we allow it for consistency and
to prevent confusion for beginners.

`!` also makes it easy to work with variables, let's take a look:
```roc
file:main.roc:snippet:bangInput
```

This gets desugared to:
```roc
file:main.roc:snippet:awaitInput
```

This is similar to before but now the `input = Stdin.line!` gets converted to `Task.await Stdin.line \input ->`.
With `!` you can write code in a mostly familiar way while also getting the benefits of Roc's
error handling and the seperation of pure and effectful code.

Note: this desugaring is very similar to that of [`?`](https://www.roc-lang.org/examples/DesugaringTry/README.html).

## Full Code
```roc
file:main.roc
```
