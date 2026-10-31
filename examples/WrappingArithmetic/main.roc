app [] {
	roc: "nightly-2026-10-31-f7bef6b",
}

### start snippet example
expect (250.U8).plus_wrap(10) == 4
expect (250.U8).plus_saturated(10) == 255

expect (0.U8).minus_wrap(1) == 255
expect (0.U8).minus_saturated(1) == 0

expect (100.I8).times_wrap(2) == -56
expect (100.I8).times_saturated(2) == 127
### end snippet example
