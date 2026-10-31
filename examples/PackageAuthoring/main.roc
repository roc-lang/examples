### start snippet header
app [] {
	greetings: "package/main.roc",
	roc: "nightly-2026-10-14-38a3029",
}

### end snippet header

### start snippet example
import greetings.Greeting

expect Greeting.for_name("Sam") == "Hello, Sam!"
### end snippet example
