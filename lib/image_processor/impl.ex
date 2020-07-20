defmodule ImageProcessor.Impl do
  @moduledoc """
  Generate a Slack color theme (8 hex colors) from an image
  """

  @doc """
  Generates a Slack Color Theme from an image file

  ## Examples

    "my_file.png" |> ImageProcessor.Impl.compute_theme
    >  "#ffffff,#bavava,..."

  """

  require Logger
  require Color

  @mapping_methods %{
    simple_sort: [0, 1, 2, 3, 4, 5, 6, 7],
    v1: [0, 4, 2, 1, 7, 6, 5, 3],
    v2: [3, 0, 1, 4, 6, 7, 2, 5]
  }

  def compute_theme(file), do: compute_theme(file, :v1)

  def compute_theme(file, mapping) do
    file
    |> histogram
    |> validate
    |> sort_and_join(mapping)
  end

  defp remap(array, order) do
    order
    |> Enum.map(fn index -> array |> Enum.at(index) end)
  end

  defp sort_and_join(validated_histogram, mapping) when is_list(validated_histogram) do
    validated_histogram
    |> sort
    |> get_hex_colors
    |> remap(@mapping_methods[mapping])
    |> Enum.join(",")
  end

  defp sort_and_join(invalid_histogram, _mapping) do
    invalid_histogram
  end

  defp validate(histogram) do
    if histogram |> is_narrow do
      nil
    else
      histogram
    end
  end

  defp sort(histogram) do
    result = histogram |> Enum.sort_by(&Color.perceptive_lightness/1)

    if histogram |> is_dark do
      result |> Enum.reverse()
    else
      result
    end
  end

  defp get_hex_colors(hist) do
    colors =
      hist
      |> Enum.map(fn %{"hex" => hex} -> hex end)

    colors |> make_eight_colors
  end

  defp make_eight_colors(colors) do
    cond do
      colors |> length > 8 ->
        colors |> Enum.slice(0, 8)

      colors |> length < 8 ->
        (colors ++ colors) |> make_eight_colors

      true ->
        colors
    end
  end

  defp lightness_range(histogram) do
    sorted =
      histogram
      |> Enum.map(&Color.perceptive_lightness/1)
      |> Enum.sort()

    [sorted |> Enum.at(0), sorted |> Enum.at(-1)]
  end

  defp is_narrow(histogram) when is_list(histogram) and length(histogram) < 6, do: true

  defp is_narrow(histogram) do
    range =
      histogram
      |> lightness_range

    ((range |> Enum.at(0)) - (range |> Enum.at(-1))) |> abs < 50
  end

  defp is_dark(histogram) do
    majority_luminance =
      histogram
      |> Enum.sort_by(fn %{"count" => count} -> count end)
      |> Enum.map(&Color.perceptive_lightness/1)
      |> Enum.at(-1)

    majority_luminance > 128.0
  end

  defp histogram(file) do
    Logger.info(fn -> "Computing histogram from #{file}" end)

    Mogrify.open(file)
    |> Mogrify.custom("-background", "white")
    |> Mogrify.custom("-alpha", "remove")
    |> Mogrify.custom("-colors", 8)
    |> Mogrify.custom("+dither")
    |> Mogrify.histogram()
    |> Enum.slice(0, 8)
  end
end
