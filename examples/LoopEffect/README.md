# Loop Effects
Sometimes, you need to repeat an [effectful](https://en.wikipedia.org/wiki/Side_effect_(computer_science)) function, multiple times until a particular event occurs. In Roc, you can use a [recursive function](https://en.wikipedia.org/wiki/Recursion_(computer_science)) to do this.

We'll demonstrate this by adding numbers read from stdin until the end of input (Ctrl-D or [end of file](https://en.wikipedia.org/wiki/End-of-file)).

## Full Code

```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc < numbers.txt 
Enter some numbers on different lines, then press Ctrl-D to sum them up.
Sum: 178
```
