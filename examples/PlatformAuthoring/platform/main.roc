platform "increment"
	requires {
		transform : I64 -> I64
	}
	exposes []
	packages {}
	provides { "roc_transform": transform_for_host }
	targets: {
		x64mac: {
			inputs: [app],
			output: Archive,
		},
		arm64mac: {
			inputs: [app],
			output: Archive,
		},
		x64glibc: {
			inputs: [app],
			output: Archive,
		},
		arm64glibc: {
			inputs: [app],
			output: Archive,
		},
		x64win: {
			inputs: [app],
			output: Archive,
		},
		arm64win: {
			inputs: [app],
			output: Archive,
		},
	}

transform_for_host : I64 -> I64
transform_for_host = |n| transform(n)
