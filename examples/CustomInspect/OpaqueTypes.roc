OpaqueTypes :: {}.{}

### start snippet color
Color := [
	Red,
	Green,
	Blue,
].{
	to_inspect : Color -> Str
	to_inspect = |color| {
		match color {
			Red => "_RED_"
			Green => "_GREEN_"
			Blue => "_BLUE_"
		}
	}
}

expect Str.inspect(Color.(Red)) == "_RED_"
expect Str.inspect(Color.(Green)) == "_GREEN_"
expect Str.inspect(Color.(Blue)) == "_BLUE_"

### end snippet color

main! = |_| {
	dbg Str.inspect(Color.(Red))
	Ok({})
}

### start snippet secret
CreditCard :: Str.{
	create = |nb| CreditCard.(nb)
	to_inspect = |CreditCard.(nb)| {
		last_four_digits = nb.to_utf8().take_last(4) |> Str.from_utf8 ?? "****" # Note: do not use this default in production. If your credit card string cannot be converted to utf8 you should fail loudly.
		"**** **** **** ${last_four_digits}"
	}
}

expect Str.inspect(CreditCard.("1111 2222 3333 1234")) == "**** **** **** 1234"
### end snippet secret
