# Error Handling Basic

Roc uses `Result ok err` types to handle errors. The `?` operator tries an operation and returns early if it fails. You can replace default errors with custom ones using `? |_| CustomError(important_info)`, if you don't want to do that, add `?` right after `)` without any spaces.

You will often see `Stdout.line!("hello")?` without a cutom error because it's very unlikely to fail.

See also:
- [Real world error handling](https://www.roc-lang.org/examples/ErrorHandlingRealWorld/README) for a more complex example.
- [Desugaring `?`](https://www.roc-lang.org/examples/TryOperatorDesugaring/README) to understand how `?` is converted under the hood.

## Full Code

```roc
file:ErrorHandlingBasic.roc
```

## Output

Run this from the directory that has `ErrorHandlingBasic.roc` in it:

```sh
$ roc test ErrorHandlingBasic.roc
0 failed and 1 passed in 102 ms.
```