### start snippet header
app [] {
	greetings: "package/main.roc",
	roc: "nightly-2026-11-21-09f4dc3",
}

### end snippet header

### start snippet example
import greetings.Greeting

expect Greeting.for_name("Sam") == "Hello, Sam!"
### end snippet example
