import Mogrify
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
  def generate(file) do
    file |> generate_theme
  end

  defp generate_theme(file) do
    histogram_data = open(file)
    |> custom("-level", "30%")
    |> custom("-colors", 8)
    |> custom("+dither")
    |> histogram(8)
    |> Enum.sort_by(fn %{"count" => count} -> count end)

    histogram_data
    |> Enum.map(fn %{"hex" => hex} -> hex end)
    |> Enum.join(",")
    |> IO.puts
  end

  defp inspector(v,s), do: (IO.puts("[#{s}] #{inspect(v)}"); v)
  defp inspector(v), do: (IO.puts("[check] #{inspect(v)}"); v)


end
