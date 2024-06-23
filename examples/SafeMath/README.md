# Safe Maths

This example shows an example which safely calculates the variance of a population.

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

Run unit tests with `roc test main.roc`
