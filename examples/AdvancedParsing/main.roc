app [] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
User := {
	user_name : Str,
	nickname ?: Str,
	email : Try(Str, [Missing]),
	role : [Restricted, Admin] ?? Restricted,
}.{
	parser_for : _
}

parse_user : Str -> Try(User, [InvalidJson(Str), MissingRequiredField(Str)])
parse_user = Json.parser_camel()

parse_headers : Str -> Try({ content_length : U64, x_auth_token : Try(Str, [Missing]) }, [BadHeader, MissingRequiredField(Str)])
parse_headers = Encoding.HttpHeader.parser_for()

expect {
	user = parse_user(
		\\{"userName": "Sam"}
	)?
	user.user_name == "Sam" and user.email == Err(Missing) and (user.?nickname ?? "anonymous") == "anonymous" and user.role == Restricted
}
expect {
	user = parse_user(
		\\{"userName": "Sam", "email": "sam@example.com"}
	)?
	user.email == Ok("sam@example.com")
}
expect {
	user = parse_user(
		\\{"userName": "Sam", "nickname": "Sammy"}
	)?
	user.?nickname == Ok("Sammy")
}
expect {
	user = parse_user(
		\\{"userName": "Sam", "role": "Admin"}
	)?
	user.role == Admin
}
expect parse_user("{}").is_err()
expect {
	headers = parse_headers("Content-Length: 42\r\n\r\n")?
	headers.content_length == 42 and headers.x_auth_token == Err(Missing)
}
### end snippet example
