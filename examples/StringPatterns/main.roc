app [] {
	roc: "nightly-2026-10-27-de79a0f",
}

### start snippet example
filename : Str -> Try(Str, [InvalidPath])
filename = |path| match path {
	"notes/${name}.txt" => Ok(name)
	_ => Err(InvalidPath)
}

expect filename("notes/todo.txt") == Ok("todo")
expect filename("notes/todo.csv") == Err(InvalidPath)

route : Str -> Try(U64, [NotFound, InvalidId])
route = |path| match path {
	"users/${id}" => U64.from_str(id).map_err(|_| InvalidId)
	_ => Err(NotFound)
}

expect route("users/42") == Ok(42)
expect route("users/alice") == Err(InvalidId)
expect route("posts/42") == Err(NotFound)
### end snippet example
