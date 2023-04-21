
# Random Numbers 

This is example uses the [JanCVanB/roc-random](https://github.com/JanCVanB/roc-random) package and Roc's [basic-cli platform](https://github.com/roc-lang/basic-cli) to generate a list of random numbers.

## Random `Generators`

Working with random numbers in Roc may seem unfamiliar if you are coming from another language. This is because, most languages provide a function like `Math.random()` to produce random numbers. However, functions in Roc provide the same output each time they are called with the same input. This makes Roc reliable and easy to test, however it also means we have to do things differently to work with random numbers.

To get random numbers in Roc we first need a `Generator` which provides psuedorandom numbers. This generates numbers using the PCG algorithm which is fast and provides numbers which are [statistically random](https://en.wikipedia.org/wiki/Statistical_randomness). To do this the `Generator` requires a `seed` value which provides the initial "randomness" for the algorithm, and each time a new value is generated. Note that if the same seed value is provided then the same number sequence will be generated each and every time.

## Output

```
% roc run examples/RandomNumbers/main.roc
Random numbers are: 37,31,29,34,67,28,46,41,63,30
```

## Code
```roc
file:main.roc
```