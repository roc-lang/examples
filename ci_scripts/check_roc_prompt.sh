#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail

prompt=$(cat ./examples/AIRocPrompt/prompt.md)

# Use a while loop with a regular expression to find and process code blocks
while [[ $prompt =~ ([a-zA-Z0-9_-]+\.roc):[ ]*$'\n'*\`\`\`([^`]*)$ ]]; do
    # Extract the .roc filename
    roc_filename="${BASH_REMATCH[1]}"
    
    # Extract the code block content
    code_block="${BASH_REMATCH[2]}"
    
    # Remove leading newlines and trailing backticks from the code block
    code_block=$(echo "$code_block" | sed -e 's/^[[:space:]]*//' -e 's/```$//')
    
    # Print the extracted information (you can modify this part to store or process the data as needed)
    echo "File: $roc_filename"
    echo "Content:"
    echo "$code_block"
    echo "------------------------"
    
    # Remove the processed part from the prompt string to continue the loop
    prompt=${prompt#*"$BASH_REMATCH"}

    # TODO Check if examples in prompt match with actual examples
done