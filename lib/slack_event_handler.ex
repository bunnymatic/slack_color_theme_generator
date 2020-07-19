defmodule SlackEventHandler do
  @moduledoc """
  Listen and respond to slack events
  """
  require Logger
  require SlackMessaging

  use Slack

  def handle_connect(slack, state) do
    Logger.info(fn -> "Connected to slack as #{slack.me.name}" end)
    {:ok, state}
  end

  # match one file
  # On 10/4/2018 it appears this matcher doesn't hit any more.  Slack appears
  # to have changed the API to send `files: files`
  def handle_event(message = %{type: "message", file: file}, slack, state) do
    Logger.info(fn -> "Processing slack uploaded file" end)

    file
    |> Map.get(:url_private)
    |> SlackHelpers.fetch_image_from_slack()
    |> process_image
    |> send_theme(message.channel, slack)

    {:ok, state}
  end

  def handle_event(message = %{type: "message", files: files}, slack, state) do
    Logger.info(fn -> "Processing slack uploaded files" end)

    files
    |> Enum.map(fn f -> f |> Map.get(:url_private) end)
    |> Enum.each(fn url ->
      url
      |> SlackHelpers.fetch_image_from_slack()
      |> process_image
      |> send_theme(message.channel, slack)
    end)

    {:ok, state}
  end

  def handle_event(
        _message = %{type: "message", message: %{thread_ts: _thread_ts}},
        _slack,
        state
      ) do
    Logger.info(fn -> "In a reply thread so keep quiet" end)
    {:ok, state}
  end

  def handle_event(
        message = %{type: "message", message: %{attachments: attachments}},
        slack,
        state
      ) do
    Logger.info(fn -> "Processing attachments" end)

    attachments
    |> Enum.map(&extract_url_from_message/1)
    |> Enum.each(fn img ->
      img
      |> SlackHelpers.fetch_image()
      |> process_image
      |> send_theme(message.channel, slack)
    end)

    {:ok, state}
  end

  def handle_event(message = %{type: "message", text: text}, slack, state) do
    # handle message that matches "#ffffff ahatever ?"
    color_regex = ~r/\#([0-9a-f]{6})\b.*\?$/i

    case color_regex |> Regex.run(text) do
      nil -> {:ok, state}
      [_, color] -> process_color_message(color, message.channel, slack, state)
    end
  end

  def handle_event(_, _, state), do: {:ok, state}

  # Not sure how this guy get's called
  def handle_info({:message, text, channel}, slack, state) do
    IO.puts("Sending your message, captain!")

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}

  def send_theme({:ok, theme}, channel, slack) do
    SlackMessaging.theme_message()
    |> send_message(channel, slack)

    send_message(theme, channel, slack)
  end

  def send_theme({:error, theme}, channel, slack) do
    if theme == nil do
      SlackMessaging.error_message()
    else
      theme
    end
    |> send_message(channel, slack)
  end

  def send_theme(_resp, _channel, _slack) do
  end

  def process_image({:ok, file_path}) do
    theme = ImageProcessor.compute_theme(file_path)

    case theme do
      "" -> {:error, nil}
      nil -> {:error, nil}
      _ -> {:ok, theme}
    end
  end

  def process_image({:error, resp}) do
    Logger.error("Unable to process image")
    Logger.error(resp.status)
    {:error, resp.status}
  end

  defp extract_url_from_message(%{:image_url => url}), do: url
  defp extract_url_from_message(%{:thumb_url => url}), do: url

  def process_color_message(color, channel, slack, state) do
    Logger.info(fn -> "Got color naming question : #{color}" end)
    color
    |> ColorNamesOrg.search()
    |> SlackMessaging.color_name_message()
    |> send_message(channel, slack)

    {:ok, state}
  end
end
