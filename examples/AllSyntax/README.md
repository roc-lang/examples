# All Syntax File

Demonstrates all Roc syntax in a single app file. See [all module types](https://roc-lang.org/tutorial#modules) to view syntax examples for the non-app headers.

## Code
```roc
file:main.roc
```

## Output

Run this from the directory that has `main.roc` in it:

```
$ roc main.roc
Hello, world!
Hello, world! (using alias)
{ default: 0, diff: 5, div: 2, div_trunc: 2, eq: False, gt: True, gteq: True, lt: False, lteq: False, neg: -10, neq: True, prod: 50, rem: 0, sum: 15 }
{ bool_and_keyword: False, bool_or_keyword: True, not_a: False }
"One Two"
"Three Four"
The color is red.
78
Success
Line 1
Line 2
Line 3
Unicode escape sequence: ✨
This is an effectful function!
Ok(1)
Err(NoFirstError(ListWasEmpty))
Err(NoFirstError(ListWasEmpty))
15.0
False
10.0
[dbg] 42.0
42.0
NotOneTwoNotFive
("Roc", 1.0)
["a", "b"]
("Roc", 1.0, 1.0, 1.0)
42
10.0
{ age: 31, name: "Alice" }
{ age: 30, name: "Alice" }
"localhost:8080 (no timeout)"
Err(MissingField)
"example.com:80 (5000ms)"
{ binary: 5.0, explicit_i128: 5, explicit_i16: 5, explicit_i32: 5, explicit_i64: 5, explicit_i8: 5, explicit_u128: 5, explicit_u16: 5, explicit_u32: 5, explicit_u64: 5, explicit_u8: 5, hex: 5.0, octal: 5.0, usage_based: 5.0 }
<opaque>
"The secret key is: my_secret_key"
False
99
"12345.0"
"Foo with 42 and hello"
"other color"
"Names: Alice, Bob, Charlie"
"A"
"other letter"
True
```

Note: the `[dbg]` line is output to stderr instead of stdout.
