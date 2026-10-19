# Iterators and Ranges

This example shows three ways to work with iterators: a lazy pipeline that selects and transforms numbers, a stepped range visited backwards, and a custom countdown iterator. Each produces a collection only when we ask for its items.

```roc
file:main.roc:snippet:example
```

The first pipeline filters for even numbers, multiplies them by ten, and collects just the first three results. Its range is large, but laziness means it stops as soon as those three results are ready. The `List(U64)` annotation tells `collect` which kind of collection to produce.

The range operators differ in how they treat the upper bound: `..<` excludes it, while `..=` includes it. In the backwards example, `step_by(2)` selects every second number, and `iter_rev` visits those same numbers in reverse order.

For the countdown, `Iter.custom` receives a function that returns `Ok((item, next_state))` for another item or `Err(NoMore)` when it is finished. We can supply `Known(start)` because we know exactly how many items it will produce; an iterator without an exact count would use `Unknown`.

Run `roc test main.roc` from this directory.
