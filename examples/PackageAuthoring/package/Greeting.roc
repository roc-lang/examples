## Greetings for application users.
Greeting := [].{

	## Build a greeting from a name.
	for_name : Str -> Str
	for_name = |name| "Hello, ${name}!"
}
