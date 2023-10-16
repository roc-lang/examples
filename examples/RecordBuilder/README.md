
# Record Builder 

This example demonstrates the Record Builder pattern in Roc. This pattern leverages the functional programming concept of applicative functors, to provide a flexible method for constructing complex types.

## The Basics

Let's assume we want to develop a module that supplies a type-safe yet versatile method for users to safely obtain sequential IDs. The record builder pattern can be beneficial in this scenario.

1. **Opaque Type** We need an opaque type that will accumulate our state:
```roc
Count a := (U32, a)
```
This type takes a type variable `a`, and holds a tuple of a `U32` and an `a`. Here, U32 will maintain our counter's value, while a houses the function to progress our builder pattern.

2. **End Goal** It's useful to visualize our desired result. The record builder pattern we're aiming for looks like:

```roc
expect
    { foo, bar, baz } = 
        from {
            foo: <- inc,
            bar: <- inc,
            baz: <- inc,
        } |> done

    foo == 1 && bar == 2 && baz == 3
```

This generates a record with fields foo, bar, and baz, all possessing sequential U32 IDs. Note the slight deviation from the conventional record syntax, using a `: <-` instead of `:`, this is the record builder pattern syntax.

3. **Under the Hood** The record builder pattern is syntax suger which converts the preceding into:

```roc
expect
    { foo, bar, baz } =
        from (\a -> \b -> \c -> { foo:a, bar:b, baz:c })
        |> inc
        |> inc
        |> inc
        |> done

    foo == 1 && bar == 2 && baz == 3
```
To make this work, we will define the functions `from` `inc` and `done`.

4. **Initial Value** Let's start with `from`:

```roc
from : a -> Count a
from = \advance ->
    @Count (0, advance)
```
`from` initiates the `Count a` value with `U32` set to `0` and stores the advance function, which is wrapped by `@Count` into our opaque type.

> Note: This usage of an opaque type ensures that, outside this module, the counter's value remains concealed (unless we purposely expose it through another function).

5. **Applicative** `inc` is defined it as:

```roc
inc : Count (U32 -> a) -> Count a
inc = \@Count (curr, advance) ->
    new = curr + 1

    @Count (new, advance new)
```

Looking at the type signature, we see that it takes a `Count a` value and applies a `U32` value to it's advance function.

`inc` unwraps the argument `@Count (curr, advance)`; calculates a new state value `new = curr + 1`; applies this new value to the provided advance function `@Count (new, advance new)`; returning a new `Count a` value.

If you haven't seen this pattern before, it can be difficult to see how this works. Let's break it down and follow the type of `a` at each step in our builder pattern.

```roc
from (\a -> \b -> \c -> { foo:a, bar:b, baz:c }) # Count (U32 -> U32 -> U32 -> { foo: U32, bar: U32, baz: U32  })
|> inc                                           # Count (U32 -> U32 -> { foo: U32, bar: U32, baz: U32 })
|> inc                                           # Count (U32 -> { foo: U32, bar: U32, baz: U32 })
|> inc                                           # Count ({ foo: U32, bar: U32, baz: U32 })
|> done
```

Above you can see the type of `a` is advanced at each step by applying a `U32` value to the function. This is also known as an applicative pipeline, and can be a flexible way to build up complex types.

6. **Unwrap** Finally, `done` unwraps the `Count a` value and return our record. 

```roc
done : Count a -> a
done = \@Count (_, final) -> 
    final
```

In our case, we don't need the `U32` state of our tuple `@Count (_, final)` and just return the record we have built.

## Basic Counter

Code for the above example is available in `BasicCounter.roc` which you can run using the following.

```sh
% roc test BasicCounter.roc

0 failed and 1 passed in 698 ms.
```

## Advanced Counter

For a more advanced example, the `AdvancedCounter.roc` example demonstrates using the record builder pattern by passing an initial value for the counter, and also taking an argument to increment the counter by.

```roc
expect
    { foo, bar, baz } =
        from 0 {
            foo: <- incBy 2,
            bar: <- incBy 3,
            baz: <- incBy 4,
        } |> done

    foo == 2 && bar == 5 && baz == 9
```