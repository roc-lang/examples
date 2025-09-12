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
{diff: 5, div: 2, div_trunc: 2, eq: Bool.false, gt: Bool.true, gteq: Bool.true, lt: Bool.false, lteq: Bool.false, neg: -10, neq: Bool.true, prod: 50, rem: 0, sum: 15}
{bool_and: Bool.false, bool_and_keyword: Bool.false, bool_or: Bool.true, bool_or_keyword: Bool.true, not_a: Bool.false}
"Pizza Roc"
42
Hello, Venus!This is a multiline string.
You can call functions inside $... too: 2
Unicode escape sequence:  
"Success"
Hello, world!
Hello, world!
Hello, world!
Hello, world!
Hello, world!
(Ok {})
"False"
("Roc", 1)
Red
[1, 2]
(TagFour 42)
default
("Roc", 1, 1, 1)
{x: 1, y: 3}
44
[./examples/AllSyntax/main.roc:119] a = 42
[./examples/AllSyntax/main.roc:122] 43 = 43
{}
4
(5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5.0, 5, 5, 5)
Rocco
42
99
(Ok {age: 25, city: "NYC", name: "Alice"})
Bool.true
```

