Hello :: {}.{
	# Only what's listed here is accessible to other modules
	hello : Str -> Str
	hello = |name| {
		"Hello ${name} from inside ${module_name}!\n"
	}
}

# Anything located outside of the Hello type can only be used in this file.
module_name = "Dir.Hello module"
