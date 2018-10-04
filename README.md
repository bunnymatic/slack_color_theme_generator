# SlackColorThemeGenerator

Generates a Slack theme (8 hex colors) based on an image

## Run it

The current implementation requires a slack hookup.  So you must have in your environment

SLACK_API_TOKEN=xoxb-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx

Then you should be able to (after `mix deps.get`) run the app
```
iex -S mix
```

# Todo

* allow both CLI and Slack to live together or at least be able to launch it as one or the other
