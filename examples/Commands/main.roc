app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.0/F1JVZPYfWP71s8vk6tHcV1Qx1Ef6CZkwswGoCn8VHZmL.tar.zst",
	roc: "nightly-2026-08-23-fb208ba",
}

import cli.Stdout
import cli.Cmd
import cli.OsStr

# Different ways to run commands like you do in a terminal.

main! = |_args| {
	# Simplest way to execute a command (prints to your terminal).
	Cmd.exec!("echo", ["Hello"])?

	# To execute and capture the output (stdout and stderr) without inheriting your terminal.
	cmd_output =
		Cmd.new("echo")
			.args(["Hi"])
			.exec_output!()?

	Stdout.line!("${Str.inspect(cmd_output)}")?

	# To run a command with environment variables.
	Cmd.new("env")
		.clear_envs() # You probably don't need to clear all other environment variables, this is just an example.
		.env("FOO", "BAR")
		.envs([("BAZ", "DUCK"), ("XYZ", "ABC")]) # Set multiple environment variables at once with `envs`
		.exec_cmd!()?

	# To execute and just get the exit code (prints to your terminal).
	# Prefer using `exec!` or `exec_cmd!`.
	exit_code =
		Cmd.new("cat")
			.args(["non_existent.txt"])
			.exec_exit_code!()?

	Stdout.line!("Exit code: ${exit_code.to_str()}")?

	# To execute and capture the output (stdout and stderr) in the original form as bytes without inheriting your terminal.
	# Prefer using `exec_output!`.
	cmd_output_bytes =
		Cmd.new("echo")
			.args(["Hi"])
			.exec_output_bytes!()?

	Stdout.line!("${Str.inspect(cmd_output_bytes)}")?

	Ok({})
}
