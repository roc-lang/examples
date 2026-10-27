### start snippet header
app [] {
	path: "https://github.com/roc-lang/path/releases/download/4.0.0/7YfABZPwJAXtLBY2vm8FqMyGAtNxncCJ65HdNKHFGNnE.tar.zst",
	roc: "nightly-2026-10-27-de79a0f",
}

### end snippet header

### start snippet example
import path.Path

config : Path
config = "config"

settings = config.join("settings.json")

expect settings.to_str() == Ok("config/settings.json")
expect settings.filename()?.to_str() == Ok("settings.json")
expect settings.ext()?.to_str() == Ok("json")

raw = Path.unix_bytes([0xff, 0x61])
expect raw.to_str().is_err()
expect raw.to_raw() == UnixBytes([0xff, 0x61])
### end snippet example
