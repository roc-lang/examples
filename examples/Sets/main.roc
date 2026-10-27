app [] {
	roc: "nightly-2026-10-27-de79a0f",
}

### start snippet example
backend = Set.from_list(["Sam", "Lee", "Sam"])

frontend = Set.from_list(["Lee", "Jo"])

expect backend.len() == 2
expect backend.contains("Sam")
expect backend.union(frontend) == Set.from_list(["Sam", "Lee", "Jo"])
expect backend.intersection(frontend) == Set.from_list(["Lee"])
expect backend.difference(frontend) == Set.from_list(["Sam"])

unique : Set(U64)
unique = [3, 1, 3].iter().collect()
expect unique.len() == 2
### end snippet example
