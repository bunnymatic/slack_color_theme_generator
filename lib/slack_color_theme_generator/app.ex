defmodule SlackColorThemeGenerator.App do
  require Logger
  use Application
  use Supervisor

  def start(_type, _args) do
    children = [
      ImageProcessor,
      SlackBotWrapper
    ]

    opts = [strategy: :one_for_one, name: Supervisor]

    Logger.info(fn -> "Starting Supervisor (App)..." end)
    Supervisor.start_link(children, opts)
  end
end
