app [] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
greet : { name : Str, ..others } -> Str
greet = |person| "Hello, ${person.name}!"

rename : { name : Str, ..others }, Str -> { name : Str, ..others }
rename = |person, name| { ..person, name }

expect greet({ name: "Sam" }) == "Hello, Sam!"
expect greet({ name: "Lee", age: 30 }) == "Hello, Lee!"
expect rename({ name: "Sam", age: 30 }, "Samantha") == { name: "Samantha", age: 30 }
### end snippet example
