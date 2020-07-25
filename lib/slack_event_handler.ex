defmodule SlackEventHandler do
  @moduledoc """
  Listen and respond to slack events
  """
  require Logger
  require SlackMessaging
  alias SlackEventHandler.Impl

  use Slack

  def handle_connect(slack, state) do
    Logger.info(fn -> "Connected to slack as #{slack.me.name}" end)
    {:ok, state}
  end

  def handle_event(message = %{type: "message", files: files}, slack, state) do
    Logger.info(fn -> "Processing slack uploaded files" end)

    files
    |> Impl.handle_files_upload()
    |> send_themes(message.channel, slack)

    {:ok, state}
  end

  def handle_event(
        _message = %{type: "message", message: %{thread_ts: _thread_ts}},
        _slack,
        state
      ) do
    {:ok, state}
  end

  def handle_event(
        message = %{type: "message", message: %{attachments: attachments}},
        slack,
        state
      ) do
    Logger.info(fn -> "Processing attachments" end)

    attachments
    |> Impl.handle_attachments()
    |> send_themes(message.channel, slack)

    {:ok, state}
  end

  # blocks include colors already parsed by Slack.
  def handle_event(message = %{type: "message", blocks: [%{ elements: elements }]}, slack, state) do
    colors = elements
    |> Enum.map(fn elements ->
      elements[:elements]
      |> IO.inspect
      |> Enum.map(&extract_value_from_element/1)
      |> Enum.filter( &(&1) )
    end) |> List.flatten |> Enum.uniq
    colors |>
      Enum.each(
        fn color -> process_color_message(color, message.channel, slack, state) end
      )
    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  # From the docs: called when any other message is received in the process mailbox.
  # Not sure when it actually hits.
  def handle_info({:message, text, channel}, slack, state) do
    Logger.info("Sending your message, captain!")

    send_message(text, channel, slack)

    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}

  def send_themes([], _channel, _slack), do: nil

  def send_themes(themes, channel, slack) do
    themes
    |> Enum.each(fn handled ->
      case handled do
        {:ok, theme} ->
          SlackMessaging.theme_message()
          |> send_message(channel, slack)

          theme |> send_message(channel, slack)

        {:error, nil} ->
          SlackMessaging.error_message() |> send_message(channel, slack)

        {:error, theme} ->
          theme |> send_message(channel, slack)

        _ ->
          nil
      end
    end)
  end

  def process_color_message(color, channel, slack, state) do
    Logger.info(fn -> "Got color naming question : #{color}" end)

    color
    |> ColorNamesOrg.search()
    |> SlackMessaging.color_name_message()
    |> send_message(channel, slack)

    {:ok, state}
  end

  defp strip_newlines(text) do
    ~r/[\r|\n]/ |> Regex.replace(text, " ")
  end

  defp extract_value_from_element(%{type: "color", value: value}) do
    value |> String.downcase |> String.replace_prefix("#", "")
  end
  defp extract_value_from_element(_), do: nil

end
