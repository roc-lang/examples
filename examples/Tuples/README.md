# Tuples

Some different uses of tuples in Roc.

A tuple is like a record, except instead of field _names_ they have field _positions_.
For example, instead of having `foo.name` to access the `name` field of a record,
you might write `foo.0` to acess the first field in a tuple (or `foo.1` for the second
field, etc.)


## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
First is: A String,
Second is: true,
Third is: 15000000.
You also have some pears.
```
