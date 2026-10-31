app [] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
import Positive

Meters := { value : U64 }.{
	is_eq : _
}

Seconds := { value : U64 }.{
	is_eq : _
}

distance = Meters.{ value: 10 }

duration = Seconds.{ value: 10 }

expect distance.value == duration.value
# distance == duration would be a type error: Meters and Seconds differ.

expect {
	count = Positive.from_u64(3)?
	count.to_u64() == 3
}
expect Positive.from_u64(0) == Err(Zero)
# Positive.(0) is forbidden here: only Positive.roc can construct it.
### end snippet example
