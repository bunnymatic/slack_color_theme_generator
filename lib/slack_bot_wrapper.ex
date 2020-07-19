defmodule SlackBotWrapper do
  require Logger

  def init(state) do
    {:ok, state}
  end

  def start_link(token) do
    Logger.info(fn -> "Starting #{__MODULE__}" end)
    Slack.Bot.start_link(SlackEventHandler, [], token)
  end

  def child_spec([token]) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [token]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
