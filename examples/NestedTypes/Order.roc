Order := { item : Str, status : Status }.{
	Status := [Pending, Shipped].{
		is_eq : _
	}

	new : Str -> Order
	new = |item| { item, status: Pending }

	ship : Order -> Order
	ship = |order| { ..order, status: Shipped }
}
