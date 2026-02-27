main! : List(Str) => Try({}, _)
main! = |_args| {

  # A tuple that contains three different types
  simple_tuple : (Str, Bool, Dec)
  simple_tuple = ("Just a String", True, 15_000_000)


  # Access the items in a tuple by index (starts at 0)
  first_item = simple_tuple.0
  second_item = if simple_tuple.1 "true" else "false"
  third_item = simple_tuple.2.to_str()

  echo!(
      \\First is: ${first_item},
      \\Second is: ${second_item},
      \\Third is: ${third_item}.
      \\
  )

  # You can also use tuples with `match`:
  fruit_selection : [Apple, Pear, Banana]
  fruit_selection = Pear

  quantity = 12

  # Create a tuple of fruites and quantities,
  # So you can match on both of them
  match (fruit_selection, quantity) {
      (_, 0) => echo!("You have no fruit.")
      (Apple, 1) => echo!("You have an apple.")
      (Apple, _) => echo!("You also have some apples.")
      (Pear, _) => echo!("You also have some pears.")
      (Banana, _) => echo!("You also have some bananas.")
  }

  Ok({})
}
