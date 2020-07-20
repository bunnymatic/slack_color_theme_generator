defmodule SlackEventHandler.Impl do
  require Logger
  require SlackMessaging

  def handle_files_upload(files) do
    files
    |> Enum.map(fn f ->
      f
      |> Map.get(:url_private)
      |> SlackHelpers.fetch_image_from_slack()
      |> process_image
    end)
  end

  def handle_attachments(attachments) do
    attachments
    |> Enum.map(fn attachment ->
      attachment
      |> extract_url_from_message
      |> SlackHelpers.fetch_image()
      |> process_image
    end)
  end

  # def handle_text_message(message, slack) do
  # end

  defp process_image({:ok, file_path}) do
    theme = ImageProcessor.compute_theme(file_path)

    case theme do
      "" -> {:error, nil}
      nil -> {:error, nil}
      _ -> {:ok, theme}
    end
  end

  defp process_image({:error, resp}) do
    Logger.error("Unable to process image")
    Logger.error(resp.status)
    {:error, resp.status}
  end

  defp extract_url_from_message(%{:image_url => url}), do: url
  defp extract_url_from_message(%{:thumb_url => url}), do: url
end
