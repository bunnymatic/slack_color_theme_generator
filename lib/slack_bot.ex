defmodule SlackBot do
  @moduledoc """
  Listen and respond to slack events
  """

  use Inspector
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message", file: file}, slack, state) do
    send_message("I got a file!", message.channel, slack)
    resp = file
    |> Map.get(:url_private)
    |> SlackClient.fetch_image
    |> process_image
    |> send_theme(message.channel, slack)

    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
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

  def send_theme({:ok, theme}, channel, slack) do
    send_message("Try this theme", channel, slack)
    send_message(theme, channel, slack)
  end

  def send_theme(_resp, _channel, _slack) do; end

  def process_image({ :ok, file_path }) do
    theme = file_path |> SlackColorThemeGenerator.generate
    { :ok, theme }
  end

  def process_image({ :error, resp }) do
    IO.puts("fail #{resp.status}")
    { :error, resp.status }
  end

end
