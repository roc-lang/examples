ImageRequest : {
	image : {
		width : U32,
		height : U32,
		title : Str,
		thumbnail : {
			url : Str,
			height : U32,
			width : U32,
		},
		animated : Bool,
		ids : List(U32),
	},
}

main! = |args| {
	input_str = match args {
		[_prog_name, first_arg, ..] => first_arg
		_ =>  # use default JSON
			\\{
			\\  "image": {
			\\    "animated": false,
			\\    "height": 600,
			\\    "ids": [116, 943, 234, 38793],
			\\    "thumbnail": {
			\\      "height": 125,
			\\      "url": "http://www.example.com/image/481989943",
			\\      "width": 100
			\\    },
			\\    "title": "View from 15th Floor",
			\\    "width": 800
			\\  }
			\\}
	}

	decoded : Try(ImageRequest, _)
	decoded = Json.parse(input_str)

	match decoded {
		Ok(record) => {
			echo!("Successfully decoded image, title:\"${record.image.title}\"\n")
			Ok({})
		}
		Err(_) => {
			echo!("Error, failed to decode image\n")
			Ok({})
		}
	}
}
