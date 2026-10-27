### start snippet header
app [] {
	roc: "nightly-2026-10-14-38a3029",
	unicode: "https://github.com/roc-lang/unicode/releases/download/4.2.0/4W8SHzvwet9hH9qZewJ1J1CVQoH7YKA6zyijWFTB3y1w.tar.zst",
}

### end snippet header

### start snippet graphemes
import unicode.Grapheme

text = "e\u(0301)🇳🇿👩‍💻"

clusters = Grapheme.split(text)

expect clusters == ["e\u(0301)", "🇳🇿", "👩‍💻"]
expect clusters.len() == 3
expect text.count_utf8_bytes() > clusters.len()

### end snippet graphemes

### start snippet scalars
import unicode.Scalar

code_points = Scalar.iter("e\u(0301)")
	.map(|item| Scalar.to_u32(item.scalar))
	.collect()

expect code_points == [0x65, 0x0301]

### end snippet scalars

### start snippet words
import unicode.Word

expect Word.slices("Don't stop!") == ["Don't", " ", "stop", "!"]

### end snippet words

### start snippet case
import unicode.Case

# Limits for input bytes, input scalars, output bytes, output scalars,
# and the mapping facts that associate output with the original text.
limits = Case.limits(1_000, 1_000, 3_000, 3_000, 1_000)

expect {
	upper = Case.to_upper("Straße", Case.unicode_default, limits)?
	Case.result_text(upper) == "STRASSE"
}

expect {
	lower = Case.to_lower("Iİ", Case.turkic, limits)?
	Case.result_text(lower) == "ıi"
}

expect {
	left = Case.fold("Straße", Case.full, limits)?
	right = Case.fold("STRASSE", Case.full, limits)?
	Case.result_text(left) == Case.result_text(right)
}
### end snippet case
