# Custom Literals

Number literals, quoted strings, and interpolated strings can create values of your own types.

## Number Literals: `from_numeral`

`Celsius.from_numeral` converts a number literal to a temperature, rejecting temperatures below absolute zero.

```roc
file:main.roc:snippet:numeral
```

The compiler passes a `Numeral` to `from_numeral`, which returns a `Try`. For a literal, Roc evaluates this method at compile time: `Ok(value)` becomes the literal's value, while `Err(_)` causes a compilation error. So `temp` has type `Celsius`, not `Try(Celsius, _)`, and needs no runtime parsing or validation.

Delegating to `Dec.from_numeral` handles the number syntax and checks that the number fits in a `Dec` before we check the temperature by calling `create`.

Note that in case of error `from_numeral` must return `Err(InvalidNumeral(Str))`. This is why we call `map_err` on the return value of `create` to convert `Err(BelowAbsoluteZero)` to `InvalidNumeral("...")`. At runtime, you are free to call `from_numeral` like any function, but in general other functions (like `create`) will have more actionable errors (i.e., tags instead of strings).

## Quoted Strings: `from_quote`

`Time.from_quote` accepts a 24-hour time in exactly `HH:MM:SS` format. In this implementation, it calls `from_str` (which parses the string and uses `from_hms` to validate the ranges) then it maps errors to the expected `BadQuotedBytes(Str)` type. This implementation allows the user to create a `Time` using a string literal at compile time (using `from_quote`), or using a `Str` at runtime (using `from_str`), or using integers at runtime (using `from_hms`).

```roc
file:main.roc:snippet:quote
```

Like `from_numeral`, `from_quote` returns a `Try`, but literal syntax unwraps `Ok` at compile time and rejects `Err`. The resulting `time` is already a validated `Time` when the program runs.

For example, changing `time` to `"02:60:00"`, or `temp` to `-300`, makes compilation fail. An explicit call such as `Time.from_quote("02:60:00")` instead returns an `Err` that the program can handle.

## Calling a Constructor at Compile Time

Compile-time evaluation also works with ordinary pure functions when their inputs are known at compile time and the result is defined at the top level.

```roc
file:main.roc:snippet:constructor
```

The ordinary call preserves its `Try`, so `maybe_time` contains `Ok(time)`. The `Ok(validated_time)` pattern unwraps the result, giving `validated_time` the inferred type `Time`. If the constructor returns `Err`, this top-level pattern fails at compile time.

## Interpolated Strings: `from_interpolation`

An interpolated literal calls `from_interpolation`. Its first argument is the text before the first interpolation. The iterator then provides each interpolated value paired with the literal text following it.

This `Html` type escapes the interpolated values while preserving the literal markup:

```roc
file:main.roc:snippet:interpolation
```

Here `name` becomes `Roc &amp; friends &lt;3`, while `<p>` and `</p>` remain markup. This example is for inserting text into HTML elements. Other contexts, such as URLs, scripts, or styles, could each handle interpolations in their own way.

Our top-level `greeting` is evaluated at compile time because all its inputs are known. Interpolation can also use runtime values, in which case escaping and assembly happen at runtime.

Note: Unlike `from_numeral` and `from_quote`, the `from_interpolation` function doesn't have to return a `Try`. This will change shortly: it will require a `Try` and the compiler will automatically unwrap `Ok` and reject `Err` (see [issue #12044](https://github.com/roc-lang/roc/issues/12044)).

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
Temperature: 37.0
Time: { hour: 2, minute: 59, second: 57 }
HTML: <p>Hello, Roc &amp; friends &lt;3!</p>
```

Run the unit tests with `roc test main.roc`.
