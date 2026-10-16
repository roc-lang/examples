Positive :: U64.{
	is_eq : _

	from_u64 : U64 -> Try(Positive, [Zero])
	from_u64 = |n| if n == 0 {
		Err(Zero)
	} else {
		Ok(Positive.(n))
	}

	to_u64 : Positive -> U64
	to_u64 = |Positive.(n)| n
}
