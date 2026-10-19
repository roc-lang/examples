# Closures

A closure is a function that can capture values from the function that creates it. Here, `make_adder` returns a function that remembers how much to add, so we can create and reuse `add_ten` and `add_twenty`.

```roc
file:main.roc:snippet:example
```

Run `roc test main.roc` from this directory.
