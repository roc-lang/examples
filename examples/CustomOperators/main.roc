app [] {
	roc: "nightly-2026-10-14-38a3029",
}

### start snippet example
Page := { number : U64 }.{
	is_eq : _

	plus : Page, U64 -> Page
	plus = |page, offset| { number: page.number + offset }

	is_lt : Page, Page -> Bool
	is_lt = |a, b| a.number < b.number

	range_inclusive_to : Page, Page -> Range(Page)
	range_inclusive_to = |first, last| Range.custom({
		lower: first,
		upper: last,
		step: Page.{ number: 1 },
		upper_bound: Inclusive,
		direction: To,
		len_if_known: Unknown,
	})

	range_iter : Page, Page, Page, [Exclusive, Inclusive], [To, From], [Known(U64), Unknown] -> Iter(Page)
	range_iter = |first, last, step, bound, direction, count|
		U64.range_iter(first.number, last.number, step.number, bound, direction, count)
			.map(|number| Page.{ number })
}

first = Page.{ number: 3 }

last = first + 2

pages : List(Page)
pages = (first..=last).iter().collect()

expect first < last
expect pages.map(|page| page.number) == [3, 4, 5]
### end snippet example
