### start snippet impl

ItemKind := [
	Text,
	Method,
	Function,
	Constructor,
	Field,
	Variable,
	Class,
	Interface,
	Module,
	Property,
].{
	is_eq : _ # enable the default is_eq implementation

	to_inspect = |ItemKind.(item_kind)| "ItemKind.(${Str.inspect(item_kind)})"

	encoder_for : encoding -> (ItemKind, state -> Try(state, []))
		where [
			encoding.encode_u32 : U32, state -> Try(state, []),
		]
	encoder_for = |_encoding| {
		Encoding : encoding
		|ItemKind.(item_kind), state| {
			u32 = match item_kind {
				Text => 1
				Method => 2
				Function => 3
				Constructor => 4
				Field => 5
				Variable => 6
				Class => 7
				Interface => 8
				Module => 9
				Property => 10
			}
			Encoding.encode_u32(u32, state)
		}
	}

	parser_for : encoding -> (state -> Try({ value : ItemKind, rest : state }, [TooShort, InvalidJson(Str), ..]))
		where [
			encoding.parse_u32 : encoding, state -> Try({ value : U32, rest : state }, [InvalidJson(Str)]),
		]
	parser_for = |encoding| {
		|state| {
			parsed = encoding.parse_u32(state) ? |InvalidJson(e)| InvalidJson(e)
			item_kind : Try(ItemKind, [TooShort, ..])
			item_kind = match parsed.value {
				1 => Ok(ItemKind.(Text))
				2 => Ok(ItemKind.(Method))
				3 => Ok(ItemKind.(Function))
				4 => Ok(ItemKind.(Constructor))
				5 => Ok(ItemKind.(Field))
				6 => Ok(ItemKind.(Variable))
				7 => Ok(ItemKind.(Class))
				8 => Ok(ItemKind.(Interface))
				9 => Ok(ItemKind.(Module))
				10 => Ok(ItemKind.(Property))
				_ => Err(TooShort)
			}
			Ok({ value: item_kind?, rest: parsed.rest })
		}
	}
}

### end snippet impl

### start snippet demo

# make a list of ItemKind's
original_list : List(ItemKind)
original_list = [
	ItemKind.(Text),
	ItemKind.(Method),
	ItemKind.(Function),
	ItemKind.(Constructor),
	ItemKind.(Field),
	ItemKind.(Variable),
	ItemKind.(Class),
	ItemKind.(Interface),
	ItemKind.(Module),
	ItemKind.(Property),
]

# encode them to JSON
encoded_str : Str
encoded_str = Json.to_str(original_list)

# check that encoding is correct
expect encoded_str == "[1,2,3,4,5,6,7,8,9,10]"

# decode back to a list of ItemKind's
decoded_list : Try(List(ItemKind), _)
decoded_list = Json.parse(encoded_str)

# check that decoding is correct
expect decoded_list == Ok(original_list)

main! = |_args| {
	# prints decoded items to stdout
	decoded_list?
		|> List.map(Str.inspect)
		|> Str.join_with("\n")
		|> echo!
	echo!("\n")
	Ok({})
}

### end snippet demo
