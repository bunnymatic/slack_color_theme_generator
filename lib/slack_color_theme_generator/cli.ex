defmodule SlackColorThemeGenerator.CLI do
  def main(args) do
    args
    |> Enum.map(&ImageProcessor.compute_theme/1)
    |> IO.puts()
  end
end
