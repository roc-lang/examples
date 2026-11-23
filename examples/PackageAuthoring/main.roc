### start snippet header
app [] {
	greetings: "package/main.roc",
	roc: "0.1.0-RC1",
}

### end snippet header

### start snippet example
import greetings.Greeting

expect Greeting.for_name("Sam") == "Hello, Sam!"
### end snippet example
