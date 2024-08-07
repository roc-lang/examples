
# AI Roc Prompt

AI assistants like chatGPT are not great at Roc because they have not been trained on a large corpus of Roc code.
However, this system prompt can improve your assitant's Roc skills. Note that this prompt is meant to make the assitant
better at writing Roc code, not at answering general questions about Roc like "What's a platform?". We plan to provide a different
prompt for that in the future.

## Claude 3.5 Sonnet Prompt

I personally use the prompt below by pasting it into the system prompt at https://console.anthropic.com/workbench
That will require you to sign up for the anthropic API, you pay per request depending on the length of the input and
model output. A typical question and answer costs me $0.03.

It's beneficial to provide the AI with code examples similar to your own. If you are only using the [basic-cli platform](https://github.com/roc-lang/basic-cli), you probably want to remove any examples that use other platforms.

[Full Prompt](https://raw.githubusercontent.com/roc-lang/examples/main/examples/AIRocPrompt/prompt.md)


## Other Models

The Claude 3.5 sonnet prompt can probably be adapted for other models/APIs like [chatGPT](https://platform.openai.com/signup) or [Llama 3.1 70b](https://identity.octoml.ai/oauth/account/sign-up). I recommend checking example system prompts created by the developers of the model. Making the system prompt more like those examples will likely result in improved performance. You can [contribute improvements or a prompt for your favorite model](https://github.com/roc-lang/examples).