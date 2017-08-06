defmodule SlackColorThemeGenerator.SlackBot do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    message |> inspector
    send_message("I got a message!", message.channel, slack)

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  defp inspector(v,s), do: (IO.puts("[#{s}] #{inspect(v)}"); v)
  defp inspector(v), do: (IO.puts("[check] #{inspect(v)}"); v)

end
