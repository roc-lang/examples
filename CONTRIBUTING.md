
## Code of Conduct

We are committed to providing a friendly, safe and welcoming environment for all. Make sure to take a look at the [Code of Conduct](https://github.com/roc-lang/roc/blob/main/CODE_OF_CONDUCT.md).

## How to contribute

All contributions are appreciated! Typo fixes, bug fixes, feature requests, example suggestions, bug reports are all helpful for the project.

If you are looking for a good place to start, check the [good first issues](https://github.com/roc-lang/examples/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) or reach out on the #contributing channel on our [group chat](https://roc.zulipchat.com/).

## Example goals

- We want the examples website to be the centralized place to find your up-to-date, roc-expert-approved answer to common search queries like "How to X in roc".
- The code snippet of the example should concisely provide the code that the user is looking for and be easy to understand. Nuanced explanations, suggestions for further reading, and links to other examples may be provided in the text part of the example.
- For the platform and packages URLs should be used, not relative links. This makes the example easy to copy.

## Contribution Tips

- If this is your first pull request on github, check out this [link](https://www.freecodecamp.org/news/how-to-make-your-first-pull-request-on-github-3/)
- Fork the repo so that you can apply your changes first on your own copy of the roc repo.
  It's a good idea to open a draft pull request as you begin working on something. This way, others can give feedback sooner rather than later and duplicate effort is avoided. Click the button "ready for review" when it's ready.


## To view the examples site locally

Clone the Roc repo if you don't have it already:
```
git clone https://github.com/roc-lang/roc.git
```

Update the path in the file `./main.roc` (of the example repo):
```
packages { pf: "/PATH_TO_ROC_REPO/examples/static-site-gen/platform/main.roc" }
```
Generate the html files:
```
roc run main.roc -- examples build 
```

Copy the static assets from `./www` to `./build`:
```
cp ./wwww/* ./build
```

If you're using the nix flake, simple-http-server will already be installed. Without nix you can do `cargo install simple-http-server`.

View the website:
```
cd ./build
simple-http-server --nocache --index
```