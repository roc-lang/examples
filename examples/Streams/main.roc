app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.25.0/CZsY7tYZwR3rj9kYbpaCfxki2yVAaRL8bBwMLvB2xkbA.tar.zst",
	roc: "nightly-2026-10-14-38a3029",
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
			Ok(bytes) if bytes.is_empty() => Err(NoMore)
			Ok(bytes) => Ok((Ok(bytes), Reading(current)))
			Err(err) => Ok((Err(err), Finished))
		}
	},
)

show_file! = |path| {
	reader = File.open_reader!(path)?

	for! result in lines(reader).take_first(2) {
		bytes = result?
		line = Str.from_utf8(bytes) ? |_| InvalidUtf8
		Stdout.write!(line)?
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
