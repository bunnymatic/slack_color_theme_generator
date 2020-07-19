defmodule SlackColorThemeGenerator.App do
  require Logger
  use Application
  use Supervisor

  def start(_type, _args) do
    children = [
      ImageProcessor,
      {SlackBotWrapper, [System.get_env("SLACK_API_TOKEN")]}
    ]

    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end
end
