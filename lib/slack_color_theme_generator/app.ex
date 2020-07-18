defmodule SlackColorThemeGenerator.App do
  require Logger
  use Application
  use Supervisor

  def start(_type, _args) do
    token = System.get_env("SLACK_API_TOKEN")

    if token do
      children = [
        %{
          id: Slack.Bot,
          start: {
            Slack.Bot,
            :start_link,
            [
              SlackColorThemeGenerator.SlackBot,
              [],
              System.get_env("SLACK_API_TOKEN")
            ]
          }
        }
      ]

      opts = [strategy: :one_for_one, name: Supervisor]

      Logger.info(fn -> "Starting SlackBot..." end)
      Supervisor.start_link(children, opts)
    else
      {:error, :ignore}
    end
  end
end
