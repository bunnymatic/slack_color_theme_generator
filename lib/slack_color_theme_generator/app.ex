defmodule SlackColorThemeGenerator.App do
  require Logger
  use Application
  use Supervisor

  def start(_type, _args) do
    token = System.get_env("SLACK_API_TOKEN")
    children = [
      ImageProcessor,
      token && {SlackBotWrapper, [token]}
    ] |> Enum.filter(&(&1))
    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end
end
