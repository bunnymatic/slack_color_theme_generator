defmodule SlackColorThemeGenerator.CLI do
  def main(args) do
    IO.inspect args
    args |> Enum.at(0) |>  SlackColorThemeGenerator.generate
  end
end
