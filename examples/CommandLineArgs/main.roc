# Run with `roc ./examples/CommandLineArgs/main.roc input.txt`

main! = |raw_args| {
	args = raw_args.map(Str.inspect)

	# get the first argument
	arg_result = args.first().map_err(|_| ZeroArgsGiven)

	match arg_result {
		Err(ZeroArgsGiven) => {
			echo!("Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc input.txt`\n")
			Err(Exit(1))
		}
		Ok(first_argument) => {
			echo!("received argument: ${first_argument}\n")
			Ok({})
		}
	}
}
