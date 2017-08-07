defmodule SlackClient do

  @moduledoc """
  Connect to slack and do things (like fetch images)
  """

  use Inspector
  use Tesla

  plug Tesla.Middleware.FollowRedirects, max_redirects: 3 # defaults to 5

  def fetch_image(image_url) do
    System.get_env("SLACK_API_TOKEN") |> inspector
    headers = %{ "Authorization" => "Bearer #{slack_token()}" }
    resp = get(image_url, headers: headers)
    |> inspector("GET response")

    if (resp.status != 200) do
      { :error, resp }
    else
      {:ok, path} = Briefly.create
      path
      |> inspector("Tempfile")
      |> File.write(resp.body)
      |> inspector("write")
      {:ok, path}
    end
  end

  defp slack_token do
    System.get_env("SLACK_API_TOKEN")
  end
end
