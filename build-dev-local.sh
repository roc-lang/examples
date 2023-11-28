#!/usr/bin/env bash

# Use this script to for testing the site locally

## Get the directory of the currently executing script
DIR="$(dirname "$0")"

# Change to that directory
cd "$DIR" || exit

rm -rf dist/

roc run main.roc -- examples/ dist/

wget "https://www.roc-lang.org/site.js" -P dist/
wget "https://www.roc-lang.org/favicon.svg" -P dist/
wget "https://www.roc-lang.org/site.css" -P dist/

cp -r www/* dist/

npx http-server dist/ -p 8080 -c-1 --cors
