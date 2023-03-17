# Useful Roc Examples

This repository stores a number of useful Roc examples to complement the [Roc Tutorial](https://www.roc-lang.org/tutorial) and other guides. 

Examples are located in each of the folders and each demonstrates different features of the Roc language and toolset.

## Running an example

You can run these examples using the Roc cli e.g. `roc run examples/basic-json/main.roc`. 

## Building the Roc Examples static site

To generate the html files from examples use the Roc cli. 

`roc run main.roc -- examples build`

Then copy the static assets from `/www` to `/build`.

## Ideas and Improvements

If you have any ideas or improvements for this repository please start a discussion over on the [Roc Zulip chat](https://roc.zulipchat.com/).

## Contributing 

Please read the [Roc Contributing](https://github.com/roc-lang/roc/blob/main/CONTRIBUTING.md) instructions.

Some additional notes to consider for Example developers:
- These Examples should support a variety of needs such as application templates, content for guides and tutorials, and helpful scripts.
- Try to keep the scope of your Example in mind. It should be something that you would personally copy or share with someone, avoid adding too many examples as they all need to be maintained.
- The platform and any packages should be URLs and not relative links. It should be as easy as navigating to a relevant example, copying it into a file, and now you have working code!
- Also note that this is not a package repository, it is intended for teaching and demonstration purposes. If you would like to publish a package please create a separate repository or fork one of the Roc examples.