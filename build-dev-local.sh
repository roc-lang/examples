#!/usr/bin/env bash

# Use this script to for testing the site locally

## Get the directory of the currently executing script
DIR="$(dirname "$0")"

# Change to that directory
cd "$DIR" || exit

rm -rf dist/

roc run main.roc -- examples/ dist/

cp -r www/* dist/

npx http-server dist/ -p 8080 -c-1 --cors
