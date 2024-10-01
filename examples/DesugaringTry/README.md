# Desugaring ?

<details>
  <summary>What's syntax sugar?</summary>
  
  Syntax within a programming language that is designed to make things easier 
  to read or express. It allows developers to write code in a more concise, readable, or
  convenient way without adding new functionality to the language itself.
</details>

Desugaring converts syntax sugar (like `x += 1`) into more fundamental operations (like `x = x + 1`).

Let's see how `?` is desugared. In this example we will extract the name and birth year from a
string like `"Alice was born in 1990"`.
```roc
file:main.roc:snippet:question
```

After desugaring, this becomes:
```roc
file:main.roc:snippet:try
```

`birthYear = Str.toU16? birthYearStr` is converted to `Str.toU16 birthYearStr |> Result.try \birthYear ->`.
As you can see, the first version is a lot nicer!

Thanks to `?`, you can write code in a mostly familiar way while also getting the benefits of Roc's
error handling.

Note: this desugaring is very similar to that of [`!`](https://www.roc-lang.org/examples/DesugaringAwait/README.html).

## Full Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
(Ok {birthYear: 1990, name: "Alice"})
(Ok {birthYear: 1990, name: "Alice"})
```
