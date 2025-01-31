# Random Numbers

Generate a list of random numbers using the [roc-random package](https://github.com/JanCVanB/roc-random) and the [basic-cli platform](https://github.com/roc-lang/basic-cli).

## Random `Generators`

Some languages provide a function like JavaScript’s `Math.random()` which can return a different number each time you call it.
However, functions in Roc are guaranteed to return the same answer when given the same arguments, this has many benefits.
But this also means something like `Math.random` couldn’t possibly be a valid Roc function!
So, we use a different approach to generate random numbers in Roc.

This example uses a `Generator` which generates pseudorandom numbers using an initial seed value and the [PCG algorithm](https://www.pcg-random.org/).
If the same seed is provided, then the same number sequence will be generated every time!
The appearance of randomness comes entirely from deterministic math being done on that initial seed.
The same is true of `Math.random()`, except that `Math.random()` silently chooses a seed for you at runtime.

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
52
34
26
69
34
35
51
74
70
39
```
