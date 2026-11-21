app [] {
	roc: "nightly-2026-11-21-09f4dc3",
}

### start snippet example
Page := { number : U64 }.{
	is_eq : _

	plus : Page, Page -> Page
	plus = |a, b| { number: a.number + b.number }

	is_lt : Page, Page -> Bool
	is_lt = |a, b| a.number < b.number

	range_inclusive_to : Page, Page -> Range(Page)
	range_inclusive_to = |first, last| Range.custom({
		lower: first,
		upper: last,
		step: Page.{ number: 1 },
		upper_bound: Inclusive,
		direction: To,
		len_if_known: Err(Unknown),
	})

	range_iter : Page, Page, Page, [Exclusive, Inclusive], [To, From], Try(U64, [Unknown]) -> Iter(Page)
	range_iter = |first, last, step, bound, direction, count|
		U64.range_iter(first.number, last.number, step.number, bound, direction, count)
			.map(|number| Page.{ number })
}

first = Page.{ number: 3 }

last = first + Page.{ number: 2 }

pages : List(Page)
pages = (first..=last).iter().collect()

expect first < last
expect pages.map(|page| page.number) == [3, 4, 5]
### end snippet example
