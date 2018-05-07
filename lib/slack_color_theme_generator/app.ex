defmodule SlackColorThemeGenerator.App do

  require Logger
  use Application
  use Supervisor

  def init(:ok)
  def start(_type, _args) do
    children = [
      %{
        id: Slack.Bot,
        start: {
          Slack.Bot, :start_link, [
            SlackColorThemeGenerator.SlackBot, [], System.get_env("SLACK_API_TOKEN")
          ]
        }
      }
    ]

    opts = [strategy: :one_for_one, name: Supervisor]

    Logger.info( fn -> "Starting SlackBot..." end )
    Supervisor.start_link(children, opts)

    #SlackColorThemeGenerator.Supervisor.start_link(name: SlackColorThemeGenerator.Supervisor)
  end

end
