defmodule SlackBotWrapper do
  def init(state) do
    {:ok, state}
  end

  def format_status(_reason, [_pdict, state]) do
    [data: [{'State', "My current state is '#{inspect(state)}', and I'm happy"}]]
  end

  def start_link(token) do
    IO.puts("Starting slack handler with #{token}")
    IO.puts(__MODULE__)
    # can we get the token from initial state?
    if token do
      Slack.Bot.start_link(SlackEventHandler, [], token)
    else
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end
  end

  def child_spec(opts) do
    token = System.get_env("SLACK_API_TOKEN")

    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [token]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
