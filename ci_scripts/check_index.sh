#!/usr/bin/env bash

# Checks if every folder in examples is mentioned in ./examples/index.md

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euo pipefail

# Directory and file to check
examples_dir="./examples"
index_file="./examples/index.md"

# Check if the index file exists
if [[ ! -f "$index_file" ]]; then
  echo "Index file ($index_file) does not exist."
  exit 1
fi

# Iterate through each directory in the examples directory
for folder in "$examples_dir"/*; do
  if [[ -d "$folder" ]]; then
    folder_name=$(basename "$folder")
    
    # Check if the folder name is mentioned in the index file
    if ! grep -q "$folder_name" "$index_file"; then
      echo "Did you forget to update '$index_file'? Folder '$folder_name' in '$examples_dir' is NOT mentioned in '$index_file'."
      exit 1
    fi
  fi
done

echo "All folders in ./examples are listed in $index_file."
exit 0
