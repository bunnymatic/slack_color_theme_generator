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

  defp perceptive_lightness(%{"red" => red, "blue" => blue, "green" => green}) do
    (0.299*red + 0.587*green + 0.114*blue)
  end

  defp join_hex_colors(hist) do
    colors = hist
    |> Enum.map(fn %{"hex" => hex} -> hex end)

    colors |> make_eight_colors |> Enum.join(",")
  end

  defp make_eight_colors(colors) do
    cond do
      ((colors |> length) > 8) ->
        colors |> Enum.slice(0,8)
      ((colors |> length) < 8) ->
        (colors ++ colors) |> make_eight_colors
      true ->
        colors
    end
  end

  defp lightness_range(histogram) do
    sorted = histogram |> sorted_by_lightness
    [ sorted |> Enum.at(0), sorted |> Enum.at(-1) ]
  end

  defp is_narrow(histogram) do
    range = histogram
    |> lightness_range
    (((range |> Enum.at(0)) - (range |> Enum.at(-1))) |> abs) < 50
  end

  defp is_dark(histogram) do
    majority_luminance = histogram
    |> sorted_by_lightness
    |> Enum.at(-1)
    majority_luminance > 128.0
  end

  defp sorted_by_lightness(histogram) do
    histogram
    |> Enum.sort_by(fn %{"count" => count} -> count end )
    |> Enum.map(&perceptive_lightness/1)
  end

  defp histogram(file) do
    Logger.info( fn -> "Computing histogram from #{file}" end)
    Mogrify.open(file)
    |> Mogrify.custom("-background", "white")
    |> Mogrify.custom("-alpha", "remove")
    |> Mogrify.custom("-colors", 8)
    |> Mogrify.custom("+dither")
    |> Mogrify.histogram
  end

end
