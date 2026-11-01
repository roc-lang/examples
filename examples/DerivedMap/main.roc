app [main!] {
	roc: "nightly-2026-11-01-48d3369",
}

### start snippet example
LoadState(a) := [Loading, Loaded(a), Failed].{
	is_eq : _
	map : _
	map! : _
}

user : LoadState({ name : Str, score : U64 })
user = Loaded({ name: "Sam", score: 21 })

expect user.map(|profile| profile.name) == Loaded("Sam")

loading : LoadState(Str)
loading = Loading

failed : LoadState(Str)
failed = Failed

expect loading.map(Str.count_utf8_bytes) == Loading
expect failed.map(Str.count_utf8_bytes) == Failed

main! = |_| {
	name = user.map!(
		|profile| {
			echo!("Loaded user: ${profile.name}\n")
			profile.name
		},
	)
	echo!("${Str.inspect(name)}\n")
	Ok({})
}
### end snippet example
