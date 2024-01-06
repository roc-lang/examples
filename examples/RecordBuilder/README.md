
# Record Builder 

This example demonstrates the Record Builder pattern in Roc. This pattern leverages the functional programming concept of [applicative functors](https://lucamug.medium.com/functors-applicatives-and-monads-in-pictures-784c2b5786f7), to provide a flexible method for constructing complex types.

## The Basics

Let's assume we want to develop a module that supplies a type-safe yet versatile method for users to obtain user IDs that are guaranteed to be sequential. The record builder pattern can be helpful here.

> Note: it is possible to achieve this sequential ID mechanism with simpler code but more "real world" record builder examples may be too complex to easily understand the mechanism. If you want to contribute, we would love to have a real world record builder example that is well explained.

### Defining Types

```roc
ID : U32
```
We define a type alias `ID` which we set to a 32 bit unsigned integer.
A type alias improves readability. Otherwise we'd have a bunch of functions that work with `U32`
where you'd need to look at the context to figure out what the type actually represents.
If you ever want to switch your ID's to use a `U64`, you would only need to change one line!

We want to protect our ID counter, other modules should not be able to alter it, otherwise two users may end up with the same ID! 
For this protection we use an [opaque type](https://www.roc-lang.org/tutorial#opaque-types) that will also accumulate our state:
```roc
IDCount state := (ID, state)
```
This type takes a type variable `state`. In our case `state` will be either a record or a function that produces a record.
`:=` is used to define an opaque type.
`(ID, state)` is a [tuple](https://www.roc-lang.org/examples/Tuples/README.html) of an `ID`(=`U32`) and our `state` type variable. 

### End Goal

It's useful to visualize our desired result. The record builder pattern we're aiming for looks like:

```roc
expect
    { aliceID, bobID, trudyID } = 
        initIDCount {
            aliceID: <- incID,
            bobID: <- incID,
            trudyID: <- incID,
        } |> extractState

    aliceID == 1 && bobID == 2 && trudyID == 3
```

This generates a record with fields `aliceID`, `bobID`, and `trudyID`, all possessing sequential IDs (= `U32`). Note the slight deviation from the conventional record syntax, using a `: <-` instead of `:`, this is the Record Builder syntax.

### Under the Hood

The record builder pattern is syntax sugar which converts the preceding into:

```roc
expect
    { aliceID, bobID, trudyID } =
        initIDCount (\aID -> \bID -> \cID -> { aliceID: aID, bobID: bID, trudyID: cID })
        |> incID
        |> incID
        |> incID
        |> extractState

    aliceID == 1 && bobID == 2 && trudyID == 3
```
To make this work, we will define the functions `initIDCount`, `incID`, and `extractState`.

## Initial Value

Let's start with `initIDCount`:

```roc
initIDCount : state -> IDCount state
initIDCount = \advanceF ->
    @IDCount (0, advanceF)
```
`initIDCount` initiates the `IDCount state` value with the `ID` (= `U32`) set to `0` and stores the advanceF function, which is wrapped by `@IDCount` into our opaque type.

## Applicative

`incID` is defined as:

```roc
incID : IDCount (ID -> state) -> IDCount state
incID = \@IDCount (currID, advanceF) ->
    nextID = currID + 1

    @IDCount (nextID, advanceF nextID)
```

`incID` unwraps the argument `@IDCount (currID, advanceF)`; calculates a new state value `nextID = currID + 1`; applies this new value to the provided advanceF function `@IDCount (nextID, advanceF nextID)`; returning a new `IDCount` value.

If you haven't seen this pattern before, it can be difficult to grasp. Let's break it down and follow the type of `state` at each step in our builder pattern.

```roc
initIDCount (\aID -> \bID -> \cID -> { aliceID: aID, bobID: bID, trudyID: cID }) # IDCount (ID -> ID -> ID -> { foo: ID, bar: ID, trudyID: ID  })
|> incID                                           # IDCount (ID -> ID -> { aliceID: ID, bobID: ID, trudyID: ID })
|> incID                                           # IDCount (ID -> { aliceID: ID, bobID: ID, trudyID: ID })
|> incID                                           # IDCount ({ aliceID: ID, bobID: ID, trudyID: ID })
|> extractState                                    # { aliceID: ID, bobID: ID, trudyID: ID }
```

Above you can see the type of `state` is advanced at each step by applying an `ID` value to the function. This is also known as an applicative pipeline, and can be a flexible way to build up complex types.

## Unwrap

Finally, `extractState` unwraps the `IDCount` value and returns our record. 

```roc
extractState : IDCount state -> state
extractState = \@IDCount (_, finalState) -> finalState
```

In our case, we don't need the `ID` count anymore and just return the record we have built.

## Full Code

```roc
file:IDCounter.roc
```

## Output

Code for the above example is available in `IDCounter.roc` which you can run like this:

```sh
% roc test IDCounter.roc

0 failed and 1 passed in 698 ms.
```
