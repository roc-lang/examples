app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.26.0/GddgvsGjiNXrHFW6au5i5dUDbTs8FinQdrgE2Gqmw53t.tar.zst",
	roc: "nightly-2026-11-01-48d3369",
}

import cli.File
import cli.Path
import cli.Stdout
import cli.Stderr

### start snippet simple
show_pipeline! = || {
	values = [1.U64, 2, 3].iter().stream().map!(
		|n| {
			Stdout.line!("Preparing ${n.to_str()}")?
			Ok(n * 10)
		},
	)

	for! result in values.take_first(2) {
		value = result?
		Stdout.line!("Got ${value.to_str()}")?
	}
	Ok({})
}

### end snippet simple

### start snippet custom
lines = |reader| Stream.custom(
	Reading(reader),
	Unknown,
	|state| match state {
		Finished => Err(NoMore)
		Reading(current) => match current.read_line!() {
			Ok(line) => Ok((Ok(line), Reading(current)))
			Err(EndOfInput) => Err(NoMore)
			Err(err) => Ok((Err(err), Finished))
		}
	},
)

show_file! = |path| {
	reader = File.open_reader!(path)?

	for! result in lines(reader).take_first(2) {
		line = result?
		Stdout.line!(line)?
	}
	Ok({})
}

### end snippet custom

run! = |args| {
	show_pipeline!()?
	path = args.get(0) ? |_| MissingPath
	show_file!(Path.from_os_str(path))
}

main! = |args| match run!(args) {
	Ok({}) => Ok({})
	Err(err) => {
		_ = Stderr.line!("Stream example failed: ${Str.inspect(err)}")
		Err(Exit(1))
	}
}
