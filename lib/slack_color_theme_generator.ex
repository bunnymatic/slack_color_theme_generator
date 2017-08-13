defmodule SlackColorThemeGenerator do
  @moduledoc """
  Generate a Slack color theme (8 hex colors) from an image
  """

  @doc """
  Generates a Slack Color Theme from an image file

  ## Examples

      % ./slack_color_theme_generator my_file.png
      #ffffff,#bavava,...

  """
  require Logger

  use Inspector

  def generate(file) do
    file
    |> histogram
    |> sort
    |> join_hex_colors
  end

  defp sort(histogram) do
    result = histogram |> Enum.sort_by(&perceptive_lightness/1)

    if ( histogram |> is_dark ) do
      result |> Enum.reverse
    else
      result
    end
  end

  defp perceptive_lightness(%{red: red, blue: blue, green: green}) do
    (0.299*red + 0.587*green + 0.114*blue)
  end

  defp join_hex_colors(hist) do
    colors = hist
    |> Enum.map(fn %{:hex => hex} -> hex end)
    if ((colors |> length) == 8) do
      colors |> Enum.join(",")
    end
  end

  defp is_dark(histogram) do
    majority_luminance = histogram
    |> Enum.sort_by(fn %{:count => count} -> count end )
    |> Enum.map(&perceptive_lightness/1)
    |> Enum.at(-1)
    majority_luminance > 128.0
  end

  defp histogram(file) do
    Logger.info( fn -> "Computing histogram" end)
    Mogrify.open(file)
    |> Mogrify.custom("-background", "white")
    |> Mogrify.custom("-alpha", "remove")
    |> Mogrify.custom("-colors", 8)
    |> Mogrify.custom("+dither")
    |> Mogrify.histogram
  end

end
