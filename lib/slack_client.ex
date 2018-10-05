defmodule SlackClient do

  @moduledoc """
  Connect to slack and do things (like fetch images)
  """
  require Logger

  use Tesla

  plug Tesla.Middleware.FollowRedirects, max_redirects: 3 # defaults to 5

  def fetch_image_from_slack(image_url) do
    Logger.info( fn -> "Fetching image from slack" end)

    headers = %{ "Authorization" => "Bearer #{slack_token()}" }
    get(image_url, headers: headers)
    |> process_response
  end

  def fetch_image(image_url) do
    Logger.info( fn -> "Fetching image from url #{image_url}" end)
    get(image_url)
    |> process_response
  end

  defp process_response(resp) do
    if (resp.status != 200) do
      Logger.error( fn -> "SlackClient: failed to process response " end)
      Logger.error( fn -> "SlackClient: #{resp}" end)
      { :error, resp }
    else
      {:ok, path} = Briefly.create
      path
      |> File.write(resp.body)
      {:ok, path}
    end
  end

  defp slack_token do
    System.get_env("SLACK_API_TOKEN")
  end
end
