# Desugaring ?

<details>
  <summary>What's syntax sugar?</summary>
  
  Syntax within a programming language that is designed to make things easier 
  to read or express. It allows developers to write code in a more concise, readable, or
  convenient way without adding new functionality to the language itself.
</details>

Desugaring converts syntax sugar (like `x + 1`) into more fundamental operations (like `Num.add(x, 1)`).

Let's see how `?` is desugared. In this example we will extract the name and birth year from a
string like `"Alice was born in 1990"`.
```roc
file:main.roc:snippet:question
```

After desugaring, this becomes:
```roc
file:main.roc:snippet:desugared
```

So `birth_year = Str.to_u16(birth_year_str)?` is converted to

```roc
when Str.to_u16(birth_year_str) is
    Err(err2) -> return Err(err2)
    Ok(birth_year) -> birth_year
```
As you can see, the first version is a lot nicer!

Thanks to `?`, you can write code in a familiar way and you get the benefits of Roc's
error handling to drastically reduce the likelihood of crashes.

## Full Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
Ok({birth_year: 1990, name: "Alice"})
Ok({birth_year: 1990, name: "Alice"})
```
