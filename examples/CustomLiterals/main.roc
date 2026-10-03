### start snippet numeral
Celsius :: Dec.{
	is_eq : _

	from_numeral : Numeral -> Try(Celsius, [InvalidNumeral(Str)])
	from_numeral = |numeral| {
		degrees = Dec.from_numeral(numeral)?
		Celsius.create(degrees).map_err(|BelowAbsoluteZero|
			InvalidNumeral("Temperature must be at least absolute zero"))
	}

	create : Dec -> Try(Celsius, [BelowAbsoluteZero])
	create = |degrees| {
		if degrees < -273.15 {
			Err(BelowAbsoluteZero)
		} else {
			Ok(Celsius.(degrees))
		}
	}

	to_dec : Celsius -> Dec
	to_dec = |Celsius.(degrees)| degrees
}

temp1 : Celsius
temp1 = 37

temp2 = 37.Celsius

### end snippet numeral

### start snippet quote
Time := { hour : U8, minute : U8, second : U8 }.{
	is_eq : _

	from_quote : Str -> Try(Time, [BadQuotedBytes(Str)])
	from_quote = |text| {
		from_str(text).map_err(
			|err| match err {
				InvalidTimeFormat => BadQuotedBytes("Invalid time format")
				InvalidTime => BadQuotedBytes("Invalid time")
			},
		)
	}

	from_str : Str -> Try(Time, [InvalidTimeFormat, InvalidTime])
	from_str = |text| {
		parts = text.split_on(":")
		if parts.any(|part| part.count_utf8_bytes() != 2) {
			return Err(InvalidTimeFormat)
		}
		nums = parts.map_try(U8.from_str) ? |BadNumStr| InvalidTimeFormat
		match nums {
			[hour, minute, second] => {
				if hour < 24 and minute < 60 and second < 60 {
					from_hms({ hour, minute, second })
				} else {
					Err(InvalidTimeFormat)
				}
			}
			_ => Err(InvalidTimeFormat)
		}
	}

	from_hms : { hour : U8, minute : U8, second : U8 } -> Try(Time, [InvalidTime])
	from_hms = |hms| {
		if hms.hour < 24 and hms.minute < 60 and hms.second < 60 {
			Ok(Time.(hms))
		} else {
			Err(InvalidTime)
		}
	}
}

time1 : Time
time1 = "02:59:57"

time2 = "02:59:57".Time

### end snippet quote

### start snippet constructor
maybe_time : Try(Time, _)
maybe_time = Time.from_hms({ hour: 2, minute: 59, second: 57 })

Ok(validated_time) = Time.from_hms({ hour: 2, minute: 59, second: 57 })

### end snippet constructor

### start snippet interpolation
Html :: Str.{
	is_eq : _

	from_interpolation : Str, Iter((Str, Str)) -> Html
	from_interpolation = |first, rest| {
		Html.(
			rest.fold(
				first,
				|html, (value, following)| {
					html.concat(Html.escape(value)).concat(following)
				},
			),
		)
	}

	# Escape interpolated text, preserving the literal markup.
	escape : Str -> Str
	escape = |text| {
		text
			.replace_each("&", "&amp;")
			.replace_each("<", "&lt;")
			.replace_each(">", "&gt;")
			.replace_each("\"", "&quot;")
			.replace_each("'", "&#39;")
	}

	to_str = |Html.(html)| html
}

name = "Roc & friends <3"

greeting1 : Html
greeting1 = "<p>Hello, ${name}!</p>"

greeting2 = "<p>Hello, ${name}!</p>".Html

### end snippet interpolation

expect temp1.to_dec() == 37
expect time1.hour == 2
expect time1.minute == 59
expect time1.second == 57
expect temp1 == temp2
expect time1 == time2
expect time1 == validated_time
expect maybe_time == Ok(time1)
expect Time.from_hms({ hour: 0, minute: 0, second: 0 }).is_ok()
expect Time.from_quote("23:59:59").is_ok()
expect Time.from_quote("24:00:00").is_err()
expect Time.from_quote("02:60:00").is_err()
expect Time.from_quote("02:59:60").is_err()
expect Time.from_quote("2:59:60").is_err()
expect Time.from_quote("2:9:0001").is_err()
expect Time.from_quote("ab:cd:ef").is_err()
expect greeting1 == greeting2
expect greeting1.to_str() == "<p>Hello, Roc &amp; friends &lt;3!</p>"
expect Html.escape("&<>'\"") == "&amp;&lt;&gt;&#39;&quot;"
expect {
	first = "<one>"
	second = "&two"
	html : Html
	html = "${first} / ${second}"
	html.to_str() == "&lt;one&gt; / &amp;two"
}

main! = |_| {
	echo!("Temperature: ${temp1.to_dec().to_str()}\n")
	echo!("Time: ${Str.inspect(time1)}\n")
	echo!("HTML: ${greeting1.to_str()}\n")
	Ok({})
}
