app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.0/F1JVZPYfWP71s8vk6tHcV1Qx1Ef6CZkwswGoCn8VHZmL.tar.zst",
	rand: "https://github.com/kili-ilo/roc-random/releases/download/0.9.2/2ZXLX8WRqrosGu1V3VL5aXqgtfTRvJmjFPx8a26ecVmc.tar.zst",
	roc: "nightly-2026-08-18-e9be50a",
}

import cli.Stdout
import cli.OsStr
import rand.Random

main! : List(OsStr) => Try({}, [Exit(I32), ..])
main! = |_args| {

	# Print a list of 10 random numbers.
	numbers_str =
		random_numbers
			.map(U32.to_str)
			|> Str.join_with("\n")

	_ = Stdout.line!(numbers_str)
	Ok({})
}

# Generate a list of random numbers using the seed `1234`.
# This is NOT cryptograhpically secure!
random_numbers : List(U32)
random_numbers = {
	{ value: numbers, state: _ } = Random.step(Random.seed(1234), numbers_generator)

	numbers
}

# A generator that will produce a list of 10 random numbers in the range 25-75.
# This includes the boundaries, so the numbers can be 25 or 75.
# This is NOT cryptograhpically secure!
numbers_generator : Random.Generator(List(U32))
numbers_generator =
	Random.list(Random.bounded_u32(25, 75), 10)

expect {
	actual = random_numbers
	actual == [59, 62, 67, 63, 41, 52, 44, 72, 42, 48]
}
