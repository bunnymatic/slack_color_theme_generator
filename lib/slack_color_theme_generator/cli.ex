defmodule SlackColorThemeGenerator.CLI do
  def main(args) do
    args |> Enum.at(0) |>  SlackColorThemeGenerator.generate
  end
end
