app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.26.0/GddgvsGjiNXrHFW6au5i5dUDbTs8FinQdrgE2Gqmw53t.tar.zst",
	roc: "nightly-2026-10-31-f7bef6b",
}

import cli.Stdout
import cli.Cmd

# Different ways to run commands like you do in a terminal.

main! = |_args| {
	# Simplest way to run a command (prints to your terminal). Anything but exit code 0 is an error.
	Cmd.call!("echo", ["Hello"])?

	# To capture the output (stdout) as text without inheriting your terminal. Anything but exit code 0 is an error.
	cmd_output =
		Cmd.new("echo")
			.arg("Hi")
			.capture!()?

	Stdout.line!("${Str.inspect(cmd_output)}")?

	# To run a command with environment variables.
	Cmd.new("env")
		.clear_envs() # You probably don't need to clear all other environment variables, this is just an example.
		.env("FOO", "BAR")
		.envs([("BAZ", "DUCK"), ("XYZ", "ABC")]) # Set multiple environment variables at once with `envs`
		.call!()?

	# To run a command and just get the exit status (prints to your terminal), a non-zero exit code is not an error.
	exit_status =
		Cmd.new("cat")
			.arg("non_existent.txt")
			.inherit_stdio()
			.run!()?
			.status

	Stdout.line!("Exit status: ${Str.inspect(exit_status)}")?

	# To run a command and get the status and the output (stdout and stderr) as data, in their original form as bytes.
	cmd_output_bytes =
		Cmd.new("echo")
			.arg("Hi")
			.run!()?
			.require_success()?
			.stdout_bytes

	Stdout.line!("${Str.inspect(cmd_output_bytes)}")?

	Ok({})
}
