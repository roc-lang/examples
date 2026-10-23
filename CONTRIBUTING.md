
## Code of Conduct

We are committed to providing a friendly, safe and welcoming environment for all. Make sure to take a look at the [Code of Conduct](https://github.com/roc-lang/roc/blob/main/CODE_OF_CONDUCT.md).

## How to contribute

All contributions are appreciated! Typo fixes, bug fixes, feature requests, example suggestions, bug reports are all helpful for the project.

If you are looking for a good place to start, check the [good first issues](https://github.com/roc-lang/examples/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) or reach out on the #contributing channel on our [group chat](https://roc.zulipchat.com/).

## Example goals

- We want the examples website to be the centralized place to find your up-to-date, roc-expert-approved answer to common search queries like "How to X in roc".
- The code snippet of the example should concisely provide the code that the user is looking for and be easy to understand. Nuanced explanations, suggestions for further reading, and links to other examples may be provided in the text part of the example.
- For the platform and packages URLs should be used, not relative links. This makes the example easy to copy.

## Roc versions

Every example pins the Roc nightly it works with in the header of its `main.roc` (or the file with the `app` header), next to its platform and packages:

```roc
app [main!] {
	cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.26.0/GddgvsGjiNXrHFW6au5i5dUDbTs8FinQdrgE2Gqmw53t.tar.zst",
	roc: "nightly-2026-10-09-258ab27",
}
```

Examples are upgraded one by one, so different examples can use different Roc versions. This way an example that depends on a platform that was not updated yet does not hold back the others.
The CI downloads the pinned nightly of each example, you can do the same locally:

- `./ci_scripts/test_example.sh HelloWorld` tests one example with its pinned nightly (set `ROC` to use another roc binary).
- `./ci_scripts/all_tests.sh` tests all examples.
- `./ci_scripts/upgrade_roc_nightly.sh [NIGHTLY_TAG]` upgrades every example that works with the (latest) nightly and leaves the others alone. This is also run daily by the `Update Roc nightly` workflow, which opens a PR.
- `./ci_scripts/update_roc_version.sh NIGHTLY_TAG [EXAMPLE_NAME...]` changes the pin without testing.

New examples need a pin in their `app` header (`app [] { roc: "nightly-..." }` is enough for a file that only has tests) and an entry in `ci_scripts/test_example.sh`.

## Contribution Tips

- If this is your first pull request on github, check out this [link](https://www.freecodecamp.org/news/how-to-make-your-first-pull-request-on-github-3/)
- Fork the repo so that you can apply your changes first on your own copy of the roc repo.
  It's a good idea to open a draft pull request as you begin working on something. This way, others can give feedback sooner rather than later and duplicate effort is avoided. Click the button "ready for review" when it's ready.