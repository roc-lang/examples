app [] {
	roc: "nightly-2026-10-14-38a3029",
}

### start snippet example
User := { id : U64, name : Str }.{
	is_eq : User, User -> Bool
	is_eq = |a, b| a.id == b.id

	to_hash : User, Hasher -> Hasher
	to_hash = |user, hasher| user.id.to_hash(hasher)
}

original = User.{ id: 7, name: "Sam" }

renamed = User.{ id: 7, name: "Samantha" }

other = User.{ id: 8, name: "Sam" }

expect original == renamed
expect original != other
expect Set.from_list([original, renamed, other]).len() == 2
expect Set.from_list([original]).contains(renamed)
### end snippet example
