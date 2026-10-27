# Unicode Text

This example uses the [unicode package](https://github.com/roc-lang/unicode) to work with user-visible characters, inspect code points, find word boundaries, and convert or compare text across writing systems. These operations need more than counting UTF-8 bytes or changing ASCII letters.

## Grapheme clusters

An accented letter, a flag, and a joined emoji can each contain several Unicode code points. `Grapheme.split` keeps those combinations together:

```roc
file:main.roc:snippet:graphemes
```

The result has three grapheme clusters. These are useful for moving a cursor through text or counting user-visible characters without splitting an accent or emoji sequence.

## Unicode scalars

When you need to inspect the individual code points instead, `Scalar.iter` visits each Unicode scalar and its position in the original string. Here, one accented grapheme contains two scalars: an `e` and a combining acute accent.

```roc
file:main.roc:snippet:scalars
```

## Word boundaries

Word segmentation follows Unicode rules rather than simply splitting on spaces. It keeps the apostrophe inside `Don't`, while preserving whitespace and punctuation as separate segments:

```roc
file:main.roc:snippet:words
```

`Word.slices` returns all segments, not just dictionary words. The slices retain the original string's backing storage.

## Case conversion and comparison

Unicode case conversion can expand a character into several characters, and some languages need different mappings. These examples turn German `ß` into `SS` and use the Turkic profile for dotted and dotless `I`:

```roc
file:main.roc:snippet:case
```

The last test uses full case folding to compare text without case differences. Folding serves a different purpose from lowercasing text for display. It does not perform Unicode normalization, so it is not a complete solution for comparing every canonically equivalent spelling.

Case operations take explicit resource limits and return `Try` values. The small budgets here are ample for these examples; `?` makes a test fail if an operation returns an error. `Case.result_text` extracts the transformed text from a result that also records how it maps to the original input.

The [package documentation](https://roc-lang.github.io/unicode) covers more features, including incremental UTF-8 decoding, line breaking, bidirectional text, and character properties.

## Output

Run this from the directory that has `main.roc` in it:

```text
$ roc test main.roc

All (8) tests passed in 266.2 ms.
```
