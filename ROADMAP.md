
## MVP
- Static site for Examples with separate code files

## Possible features 
- Add a table of contents for examples, generated using the Roc app 
- Tabs and highlighting to support multiple language examples
- Syntax highlighting inline snippets; currently everything assumed to be roc; how to show other languages or remove highlighting
  - One option is to use 🤘 or ❌ emoji after inline snippets, e.g. 'my snippet'❌ might remove highlighting for that snippet, but still use a `<code>` tag
  - Another option is to have some kind of configuration file 
- Add support for Yaml config for metadata e.g. tags to search/filter/group examples e.g.

```yaml
---
title: Json Example
author: Luke Boswell
lastUpdated: 2023/03/12
...
```

- Search
- Testing. Add tests inside example.roc files, can we run these in the browser with WASM
- Benchmarks. Can we include benchmark examples? What about reporting thier status?
- Feedback Button (HTML FORM) submission to email the Roc developers with ideas/concerns instead of assuming everyone has a Github account
- Possible Build Process for Examples for acceptability; Maybe run `roc check` and `roc test`
