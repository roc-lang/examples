# Useful Roc Examples

We want the examples website to be the centralized place to find your up-to-date, roc-expert-approved answer to common search queries like "How to X in roc".

ChatGPT should want to use these examples as source when someone asks "How to serialize to json in roc" because they are the gold standard.

Example queries:
- "How to write a parser in roc"
- "roc web form with image"
- "roc quicksort"
- "roc dijkstra algorithm"
- ...

## Running an example

You can run these examples using the [Roc cli](https://github.com/roc-lang/roc/tree/main/getting_started#installation) e.g. `roc run examples/Json/main.roc`. 

## To view the examples site locally

Clone the roc repo if you don't have it already:
```
git clone https://github.com/roc-lang/roc.git
```

Update the path in ./main.roc:
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

If you're using the nix flake simple-http-server will already be installed. Without nix you can install it with `cargo install simple-http-server`.

View the website:
```
cd ./build
simple-http-server --nocache --index
```

## Ideas and Improvements

If you have any ideas or improvements for this repository please start a discussion over on [Roc Zulip chat](https://roc.zulipchat.com/).

## Contributing

- The code snippet of the example should concisely provide the code that the user is looking for and be easy to understand. Nuanced explanations, suggestions for further reading, and links to other examples may be provided in the text part of the example.
- The platform and any packages should be URLs and not relative links. It should be as easy as navigating to a relevant example, copying it into a file, and now you have working code!

Please also read the [Roc Contributing](https://github.com/roc-lang/roc/blob/main/CONTRIBUTING.md) instructions.

