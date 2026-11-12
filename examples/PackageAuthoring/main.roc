### start snippet header
app [] {
	greetings: "package/main.roc",
	roc: "nightly-2026-11-12-ce942d6",
}

### end snippet header

### start snippet example
import greetings.Greeting

expect Greeting.for_name("Sam") == "Hello, Sam!"
### end snippet example
