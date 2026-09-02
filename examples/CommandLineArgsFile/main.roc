# Run with `roc ./examples/CommandLineArgsFile/main.roc -- examples/CommandLineArgsFile/input.txt`
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.0/F1JVZPYfWP71s8vk6tHcV1Qx1Ef6CZkwswGoCn8VHZmL.tar.zst",
	roc: "nightly-2026-09-02-d2609e2",
}

import cli.Stdout
import cli.Stderr
import cli.File
import cli.Path

run! = |args| {
	# get the second argument, the first is the executable's path
	first_arg = List.get(args, 1) ? |_| ZeroArgsGiven

	reader = File.open_reader!(Path.from_os_str(first_arg)) ? |err| FileReadFailed(first_arg, err)
	file_first_line_utf8 = reader.read_line!() ? |err| FileReadFailed(first_arg, err)
	file_first_line_str = Str.from_utf8(file_first_line_utf8) ? |_| InvalidUtf8

	Stdout.line!("First line in file:\n${file_first_line_str}")
}

main! = |args| {
	match run!(args) {
		Ok(_) => Ok({})
		Err(ZeroArgsGiven) => {
			_ = Stderr.line!("Error ZeroArgsGiven:\n\tI expected one argument, but I got none.\n\tRun the app like this: `roc main.roc -- input.txt`")
			Err(Exit(1))
		}
		Err(FileReadFailed(first_arg, file_err)) => {
			_ = Stderr.line!("Error FileReadFailed:\n\tI tried to read the file at path: `${first_arg |> Str.inspect}`\n\tBut I got this error: `${file_err |> Str.inspect}`")
			Err(Exit(1))
		}
		Err(InvalidUtf8) => {
			_ = Stderr.line!("Error InvalidUtf8:\n\tThe first line in the file is not encoded using valid UTF-8.")
			Err(Exit(2))
		}
		Err(err) => Err(err)
	}
}
