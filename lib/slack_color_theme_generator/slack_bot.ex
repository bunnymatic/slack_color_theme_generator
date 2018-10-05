defmodule SlackColorThemeGenerator.SlackBot do
  @moduledoc """
  Listen and respond to slack events
  """
  require Logger

  use Slack

  def handle_connect(slack, state) do
    Logger.info( fn -> "Connected to slack as #{slack.me.name}" end )
    {:ok, state}
  end

  # match one file
  # On 10/4/2018 it appears this matcher doesn't hit any more.  Slack appears
  # to have changed the API to send `files: files`
  def handle_event(message = %{type: "message", file: file}, slack, state) do
    Logger.info( fn -> "Processing slack uploaded file" end)
    file
    |> Map.get(:url_private)
    |> SlackClient.fetch_image_from_slack
    |> process_image
    |> send_theme(message.channel, slack)

    {:ok, state}
  end

  def handle_event(message = %{type: "message", files: files}, slack, state) do
    Logger.info( fn -> "Processing slack uploaded files" end)
    files
    |> Enum.map(fn(f) -> f |> Map.get(:url_private) end)
    |> Enum.each(fn url ->
      url
      |> SlackClient.fetch_image_from_slack
      |> process_image
      |> send_theme(message.channel, slack)
    end)

    {:ok, state}
  end

  def handle_event(_message = %{type: "message", message: %{ thread_ts: _thread_ts }}, _slack, state) do
    Logger.info( fn -> "In a reply thread so keep quiet" end)
    { :ok, state }
  end

  def handle_event(message = %{type: "message", message: %{ attachments: attachments }}, slack, state) do
    Logger.info( fn -> "Processing attachments" end)
    attachments
    |> Enum.map( &extract_url_from_message/1 )
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
    random_themer_message()
    |> send_message(channel, slack)
    send_message(theme, channel, slack)
  end

  def send_theme({:error, theme}, channel, slack) do
    if (theme == nil) do
      random_themer_error_message()
    else
      theme
    end |> send_message(channel, slack)
  end

  def send_theme(_resp, _channel, _slack) do; end

  def process_image({ :ok, file_path }) do
    theme = file_path |> SlackColorThemeGenerator.generate

    case theme do
         "" -> { :error, nil }
         nil -> { :error, nil }
         _ -> { :ok, theme }
       end
  end

  def process_image({ :error, resp }) do
    IO.puts("fail #{resp.status}")
    { :error, resp.status }
  end

  defp extract_url_from_message(%{:image_url => url}), do: url
  defp extract_url_from_message(%{:thumb_url => url}), do: url

  defp random_themer_error_message do
    [ "And what am I supposed to do with that?",
      "¯\\_(ツ)_/¯",
      "Nice try.",
      "Eh?",
      "Sometimes animated GIFs don't agree with my delicate disposition.",
      "You call that a picture?"
    ]
    |> Enum.random
  end

  defp random_themer_message do
    ["Awesome :thumbsup:",
     "Great idea! :cloud:",
     "Color me dazzled! :coffee:",
     "A regular Leonardo :paw_prints:",
     "Look out, Rauschenberg :space_invader:",
     "You're a natural designer! :lower_left_paintbrush:",
     "Theme it up! :cat2:",
     "That picture is super! :smile_cat:",
     "You rule the school! :footprints:",
     "So good! :100:",
     "Hot! :thermometer:"
     ]
    |> Enum.random
  end
end
