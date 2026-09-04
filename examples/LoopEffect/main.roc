app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.0/F1JVZPYfWP71s8vk6tHcV1Qx1Ef6CZkwswGoCn8VHZmL.tar.zst",
	roc: "nightly-2026-09-03-62fcb65",
}

import cli.Stdin
import cli.Stdout
import cli.Stderr
import cli.OsStr

## recursive function that sums every number that is provided through stdin
add_number_from_stdin! : I64 => Try(I64, _)
add_number_from_stdin! = |sum| {
	match Stdin.line!() {
		Ok(input) => {
			num = I64.from_str(input) ? |_| NotNum(input)
			add_number_from_stdin!((sum + num))
		}
		Err(EndOfFile) => Ok(sum)
		Err(err) => Err(NotNum(Str.inspect(err)))
	}
}

run! : () => Try({}, _)
run! = || {
	Stdout.line!("Enter some numbers on different lines, then press Ctrl-D to sum them up.")?

	sum = add_number_from_stdin!(0)?

	Stdout.line!("Sum: ${sum.to_str()}")
}

main! : List(OsStr) => Try({}, [Exit(I32), ..])
main! = |_args| {
	match run!() {
		Ok({}) => Ok({})
		Err(NotNum(text)) => {
			_ = Stderr.line!("Error: \"${text}\" is not a valid I64 number.")
			Err(Exit(1))
		}
		Err(err) => {
			_ = Stderr.line!("Error: ${Str.inspect(err)}")
			Err(Exit(1))
		}
	}
}
