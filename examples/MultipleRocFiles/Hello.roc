# Only what's listed here is accessible/exposed to other modules
module [hello]

hello : Str -> Str
hello = |name|
    "Hello ${name} from module!"
