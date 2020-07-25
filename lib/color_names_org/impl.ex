defmodule ColorNamesOrg.Impl do
  use Tesla
  plug(Tesla.Middleware.BaseUrl, "https://colornames.org")
  plug(Tesla.Middleware.FollowRedirects, max_redirects: 3)
  plug(Tesla.Middleware.JSON)
  #  plug Tesla.Middleware.Headers, [{"auth","xxx"}]

  def search(hex_color) do
    sanitized_color = ~r/^#/ |> Regex.replace(hex_color |> String.downcase() |> String.trim(), "")

    case get("/search/json/", query: [hex: sanitized_color]) do
      {:ok, %{body: %{"name" => color_name}}} -> %{color: "##{sanitized_color}", name: color_name}
      _ -> nil
    end
  end
end
