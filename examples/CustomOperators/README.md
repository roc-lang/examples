# Custom Operators

This example gives a custom `Page` type support for `+`, `<`, and `..=`. It shows how defining methods lets us use familiar operators to advance a page number, compare pages, and iterate over a range of pages.

```roc
file:main.roc:snippet:example
```

Each operator calls a method on `Page`:

- `+` calls `plus`, which adds an offset to the page number.
- `<` calls `is_lt`, which compares the two page numbers.
- `..=` calls `range_inclusive_to`, which creates a range including its last page.

The `range_iter` method makes that range iterable by delegating stepping and bounds to `U64`, then wrapping each number in a `Page`. Supporting other operators would require their corresponding methods too; Roc does not infer them from these definitions. See [here](https://roc-lang.org/docs/main/langref/operators/) for a complete list.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (2) tests passed in 25.9 ms.
```
