defmodule SlackColorThemeGenerator.App do
  require Logger
  use Application

  alias SlackColorThemeGenerator.Supervisor

  def start(_type, _args) do
    Supervisor.start_link(name: Supervisor)
  end
end
