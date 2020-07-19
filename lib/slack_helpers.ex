defmodule SlackHelpers do
  @moduledoc """
  Connect to slack and do things (like fetch images)
  """
  require Logger

  use Tesla

  # defaults to 5
  plug(Tesla.Middleware.FollowRedirects, max_redirects: 3)

  def fetch_image_from_slack(image_url) do
    Logger.info(fn -> "Fetching image from slack #{image_url}" end)

    headers = [{"authorization", "Bearer #{slack_token()}"}]

    case get(image_url, headers: headers) do
      {:ok, response} -> response |> process_response
      {_, response} -> {:error, response}
    end
  end

  def fetch_image(image_url) do
    Logger.info(fn -> "Fetching image from url #{image_url}" end)

    case get(image_url) do
      {:ok, response} -> response |> process_response
      {_, response} -> {:error, response}
    end
  end

  defp process_response(resp) do
    if resp.status != 200 do
      Logger.error(fn -> "SlackHelpers: failed to process response " end)
      Logger.error(fn -> "SlackHelpers: #{resp}" end)
      {:error, resp}
    else
      case Briefly.create() do
        {:ok, path} ->
          path |> File.write(resp.body)
          {:ok, path}
        {:error, error} -> {:error, error}
      end
    end
  end

  defp slack_token do
    System.get_env("SLACK_API_TOKEN")
  end
end
