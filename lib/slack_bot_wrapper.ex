defmodule SlackBotWrapper do
  require Logger

  def init(state) do
    {:ok, state}
  end

  def format_status(_reason, [_pdict, state]) do
    [data: [{'State', "My current state is '#{inspect(state)}', and I'm happy"}]]
  end

  def start_link(token) do
    Logger.info(fn -> "Starting #{__MODULE__} with #{token}" end)

    if token do
      Slack.Bot.start_link(SlackEventHandler, [], token)
    else
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end
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
