# Streams and for!

Streams let a pipeline perform effects as its items are requested. This file starts with a small pipeline that prints messages, then shows how to create a custom stream for reading lines from a file with basic-cli.

## Using a stream

Calling `.stream()` on an iterator lets us use `.map!()` for an effectful transformation. Here, preparing each value prints a message, and `for!` consumes the results:

```roc
file:main.roc:snippet:simple
```

This prints:

```text
Preparing 1
Got 10
Preparing 2
Got 20
```

Preparation and consumption alternate because the pipeline is lazy. `.take_first(2)` stops it before the third value is prepared. The `Try` values and `?` handle possible errors when writing to standard output.

An ordinary `for` loop consumes a pure iterator, although its body may still perform effects. Streams are useful when producing or transforming the items also needs effects, as the `.map!()` callback does here.

## Creating a stream from file reads

The `basic-cli` platform provides `read_line!()`, which reads one line at a time, but does not provide a ready-made stream of lines. The `lines` function below adapts those individual reads into a custom stream. This lets callers use the same pipeline operations and `for!` syntax as in the first example:

```roc
file:main.roc:snippet:custom
```

A custom stream supplies its initial state, a size hint (`Unknown` here), and a callback that produces the next item and state. In this example:

- `Reading(reader)` keeps the buffered reader available for the next pull.
- An empty byte list signals the end of the file, represented by `Err(NoMore)`. A blank line contains a newline, so it is still an item.
- A read error is yielded as an item containing `Err(err)`, followed by the `Finished` state. This lets the caller report the error rather than silently treating it as the end of the file.

The loop uses `?` to propagate read and UTF-8 errors. Since `read_line!()` retains the newline, `Stdout.write!()` prints the text without adding another one. The reader closes automatically when its last reference is dropped.

The sample file contains three lines:

```text
file:input.txt
```

## Output

Run both examples from the directory that has `main.roc` and `input.txt` in it:

```text
$ roc main.roc -- input.txt
Preparing 1
Got 10
Preparing 2
Got 20
Hello from a file!
Streams read on demand.
```

Only two lines are requested from the reader. `basic-cli` may buffer bytes ahead internally, but the app does not load the whole file into a string or a list of lines.
