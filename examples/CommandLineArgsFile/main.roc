# Run with `roc ./examples/CommandLineArgsFile/main.roc -- examples/CommandLineArgsFile/input.txt`
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.26.0-rc3/72LPrJNPhao1zzEbawpgzKnkwAPRKy6Xm8jM1rPchQ7o.tar.zst",
	roc: "nightly-2026-10-19-601b54c",
}

import cli.Stdout
import cli.Stderr
import cli.File
import cli.Path

run! = |args| {
	first_arg = List.get(args, 0) ? |_| ZeroArgsGiven

	reader = File.open_reader!(Path.from_os_str(first_arg)) ? |err| FileReadFailed(first_arg, err)
	file_first_line_str = reader.read_line!() ? |err| FileReadFailed(first_arg, err)

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
		Err(err) => Err(err)
	}
}
