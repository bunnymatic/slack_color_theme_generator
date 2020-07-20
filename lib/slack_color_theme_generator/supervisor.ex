defmodule SlackColorThemeGenerator.Supervisor do
  use Supervisor

  def init(:ok) do
    token = System.get_env("SLACK_API_TOKEN")

    children =
      [
        ImageProcessor,
        ColorNamesOrg,
        token && {SlackBotWrapper, [token]}
      ]
      |> Enum.filter(& &1)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end
end
