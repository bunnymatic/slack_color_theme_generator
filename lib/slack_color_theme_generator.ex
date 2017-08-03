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
    open(file)
    |> histogram(8)
    |> Enum.join(",")
    |> IO.puts
  end

end
