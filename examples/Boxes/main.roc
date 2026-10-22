app [] {
	roc: "nightly-2026-10-14-38a3029",
}

### start snippet example
Snapshot : { width : U64, height : U64, title : Str, pixels : List(U8) }

Event : [KeyPress(U8), SnapshotReady(Box(Snapshot))]

image : Snapshot
image = { width: 2, height: 1, title: "Preview", pixels: [0, 255] }

event : Event
event = SnapshotReady(Box.box(image))

pixel_count : Event -> U64
pixel_count = |value| match value {
	KeyPress(_) => 0
	SnapshotReady(boxed) => Box.unbox(boxed).pixels.len()
}

expect pixel_count(event) == 2
expect pixel_count(KeyPress(65)) == 0
expect Box.box(image).unbox() == image
### end snippet example
