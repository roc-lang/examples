app [] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
Expr := [Number(I64), Add(Expr, Expr), Block(List(Stmt))].{
	eval : Expr -> I64
	eval = |expr| match expr {
		Number(n) => n
		Add(left, right) => eval(left) + eval(right)
		Block(statements) => statements.fold(
			0,
			|_, statement| match statement {
				Stmt.Yield(value) => eval(value)
			},
		)
	}
}

Stmt := [Yield(Expr)]

expression : Expr
expression = Block([Stmt.Yield(Add(Number(20), Number(22)))])

expect Expr.eval(expression) == 42
expect Expr.eval(Block([])) == 0
### end snippet example
