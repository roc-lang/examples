# Boxes

This example uses `Box` to keep a large snapshot payload from making every `Event` value large. The snapshot is stored behind a pointer, while smaller events such as key presses can stay compact. This can save space when many events are stored in a `List(Event)`, particularly if most are key presses. Boxing does allocate memory, though, so whether it helps depends on the data you are storing.

```roc
file:main.roc:snippet:example
```

`Box.unbox` retrieves the snapshot so we can read its pixels. Boxes themselves cannot be compared with `==`, but their contents can be compared after unboxing.

You do not need to add boxes just to make a nominal type recursive; Roc handles that representation for you.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (3) tests passed in 13.3 ms.
```
