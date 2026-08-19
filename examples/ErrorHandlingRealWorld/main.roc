app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.22.0/F1JVZPYfWP71s8vk6tHcV1Qx1Ef6CZkwswGoCn8VHZmL.tar.zst",
	roc: "nightly-2026-08-19-edec830",
}

import cli.Stdout
import cli.Stderr
import cli.Env
import cli.Http
import cli.Utc
import cli.Path
import cli.OsStr
import cli.Url

usage = "HELLO=1 roc main.roc -- \"https://www.roc-lang.org\" roc.html"

run! = |args| {
	# Get time since [Unix Epoch](https://en.wikipedia.org/wiki/Unix_time)
	start_time = Utc.now!()

	# Read the HELLO environment variable
	hello_env = read_env_var!("HELLO")?

	Stdout.line!("HELLO env var was set to ${hello_env}.")?

	# Read command line arguments
	{ url, output_path } = parse_args!(args)?

	Stdout.line!("Fetching content from ${url}...")?

	# Fetch the provided url using HTTP
	html_str = fetch_html!(url)?

	Stdout.line!("Saving HTML to ${OsStr.display(output_path.to_os_str())}...")?

	# Write HTML string to a file
	output_path.write_utf8!(html_str) ? |err| FailedToWriteFile(OsStr.display(output_path.to_os_str()), err)

	# Print contents of current working directory
	cwd_contents = list_cwd_contents!({})?

	Stdout.line!("Contents of current directory: ${cwd_contents}")?

	end_time = Utc.now!()

	run_duration = Utc.delta_as_millis(start_time, end_time)

	Stdout.line!("Run time: ${run_duration.to_str()} ms")?

	Stdout.line!("Done")
}

parse_args! = |args| {
	match args {
		[_, first_arg, second_arg, ..] => {
			url = OsStr.display(first_arg)
			Ok({ url, output_path: Path.from_os_str(second_arg) })
		}
		bad_args => Err(FailedToReadArgs(bad_args))
	}
}

read_env_var! = |env_var_name| {
	match Env.var!(OsStr.from_str(env_var_name)) {
		Ok(env_var_os_str) => {
			env_var_str = OsStr.display(env_var_os_str)
			if Str.is_empty(env_var_str) {
				Err(EnvVarSetEmpty(env_var_name))
			} else {
				Ok(env_var_str)
			}
		}
		Err(VarNotFound(var_os_str)) => Err(VarNotFound(var_os_str))
		Err(other) => Err(OtherEnvErr(Str.inspect(other)))
	}
}

fetch_html! = |url_str| {
	url = Url.parse(url_str) ? |err| FailedToParseUrl(url_str, err)
	html_str = Http.get_utf8!(url) ? |err| FailedToFetchHtml(url_str, err)
	Ok(html_str)
}

list_cwd_contents! = |{}| {
	p = Path.from_os_str(OsStr.from_str("."))
	dir_contents = p.list!() ? |err| FailedToListCwd(err)

	contents_str =
		dir_contents
			.map(|path| OsStr.display(path.to_os_str()))
			|> Str.join_with(",")

	Ok(contents_str)
}

# In a professional application, it's recommended to use error tags throughout your program and
# convert them into user-friendly messages (in the user's language) at the application's edge.
main! = |args| {
	match run!(args) {
		Ok(_) => Ok({})
		Err(FailedToReadArgs(bad_args)) => {
			_ = Stderr.line!(
				\\Failed to read command line arguments, I received: ${Str.inspect(bad_args)}
				\\
				\\Example usage: ${usage}
				,
			)
			Err(Exit(1))
		}
		Err(VarNotFound(var_os_str)) => {
			var_name = OsStr.display(var_os_str)
			_ = Stderr.line!(
				\\Environment variable '${var_name}' was not found.
				\\Set the variable before running the application.
				\\
				\\Example usage: ${usage}"
				,
			)
			Err(Exit(1))
		}
		Err(EnvVarSetEmpty(var_name)) => {
			_ = Stderr.line!(
				\\Environment variable '${var_name}' was empty.
				\\Provide a non-empty value for this variable.
				\\
				\\Example usage: ${usage}
				,
			)
			Err(Exit(1))
		}
		Err(FailedToParseUrl(url, err)) => {
			_ = Stderr.line!(
				\\Failed to parse URL: ${url}
				\\Error: ${Str.inspect(err)}
				\\
				\\Example usage: ${usage}
				,
			)
			Err(Exit(1))
		}
		Err(FailedToFetchHtml(url, err)) => {
			_ = Stderr.line!(
				\\Failed to fetch HTML content for URL: ${url}
				\\Error: ${Str.inspect(err)}
				\\
				\\Check the URL and your internet connection.
				\\
				\\Example usage: ${usage}
				,
			)
			Err(Exit(1))
		}
		Err(FailedToWriteFile(path_str, err)) => {
			_ = Stderr.line!(
				\\Failed to write file: ${path_str}
				\\Error: ${Str.inspect(err)}
				\\
				\\Example usage: ${usage}
				,
			)
			Err(Exit(1))
		}
		Err(FailedToListCwd(err)) => {
			_ = Stderr.line!(
				\\Failed to list contents of current directory.
				\\Error: ${Str.inspect(err)}
				\\
				\\Example usage: ${usage}
				,
			)
			Err(Exit(1))
		}
		Err(other) => {
			_ = Stderr.line!(
				\\An unexpected error occurred: ${Str.inspect(other)}
				\\
				\\Example usage: ${usage}
				,
			)
			Err(Exit(1))
		}
	}
}
