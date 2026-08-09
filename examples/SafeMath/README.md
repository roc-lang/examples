# Safe Maths

This example shows how to perform calculations while avoiding overflows.
For example; `+` actually uses `plus`, which can crash if the bytes of the result can not fit in the provided type:
```cli
» U64.highest + U64.highest
This Roc code crashed with: "Integer addition overflowed!"

* : U64
```
If you want to avoid a program-ending crash, you can instead use `plus_try`:
```
» U64.highest.plus_try(U64.highest)
Err(Overflow)
```
That would allow you to display a clean error to the user or handle the failure in an intelligent way, so that your user does not lose all their progress!
Use `*_try` math functions if [reliability is important for your application](https://arstechnica.com/information-technology/2015/05/boeing-787-dreamliners-contain-a-potentially-catastrophic-software-bug/).

For a realistic demonstration, we will use `*_try` math functions to calculate the variance of a population.

The variance formula is: `σ² = ∑(X - µ)² / N` where:
- `σ²` = variance
- `X` = each element
- `µ` = mean of elements
- `N` = length of list

## Code

```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
σ² = 147.666666666666666666
```

Run unit tests with `roc test main.roc`:

```
$ roc test main.roc
All (5) tests passed in 19.9 ms.
```
