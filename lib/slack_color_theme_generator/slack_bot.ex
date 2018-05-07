defmodule SlackColorThemeGenerator.SlackBot do
  @moduledoc """
  Listen and respond to slack events
  """
  require Logger

  use Inspector
  use Slack

  def handle_connect(slack, state) do
    Logger.info( fn -> "Connected to slack as #{slack.me.name}" end )
    {:ok, state}
  end

  def handle_event(message = %{type: "message", file: file}, slack, state) do
    Logger.info( fn -> "Processing slack uploaded file" end)
    file
    |> Map.get(:url_private)
    |> SlackClient.fetch_image_from_slack
    |> process_image
    |> send_theme(message.channel, slack)

    {:ok, state}
  end

  def handle_event(message = %{type: "message", message: %{ attachments: attachments }}, slack, state) do
    Logger.info( fn -> "Processing attachments" end)
    attachments
    |> Enum.map( fn %{:image_url => url} -> url end )
    |> Enum.each( fn img ->
      img
      |> SlackClient.fetch_image
      |> process_image
      |> send_theme(message.channel, slack)
    end )

    {:ok, state}
  end

  # def handle_event(_message = %{type: "message", text: text}, _slack, state) do
  # end

  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  def send_theme({:ok, theme}, channel, slack) do
    random_themer_message
    |> send_message(channel, slack)
    send_message(theme, channel, slack)
  end

  # def send_theme({:error, theme}, channel, slack) do
  #   send_message("I couldn't find 8 decent colors in that picture...", channel, slack)
  # end

  def send_theme(_resp, _channel, _slack) do; end

  def process_image({ :ok, file_path }) do
    theme = file_path |> SlackColorThemeGenerator.generate

    case theme do
         "" -> { :error, "no theme created" }
         nil -> { :error, "no theme created" }
         _ -> { :ok, theme }
       end
  end

  def process_image({ :error, resp }) do
    IO.puts("fail #{resp.status}")
    { :error, resp.status }
  end

  defp random_themer_message do
    ["Awesome :thumbsup:",
     "Great idea! :cloud:",
     "You're a natural designer! :lower_left_paintbrush:",
     "Theme it up! :cat2:",
     "That picture is awesome! :smile_cat:",
     "You rule! :footprints:",
     "So good! :100:",
     "Hot! :thermometer:"
     ]
    |> Enum.random
  end
end
