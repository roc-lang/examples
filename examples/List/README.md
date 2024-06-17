# List Pattern Matching

A Roc solution to finding an element in a list. Here we use pattern matching on a list to check if the searched element is present in the list. If the head matches we return True if not, we continue searching the tail of the list. A base case of empty list is included which will always return false.

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc run
List [1,2,3,4,5,6,7,8,9,10] has a length of 10
5 found at index 4 in the list [1,2,3,4,5,6,7,8,9,10]

```

You can also use `roc test` to run the tests.
