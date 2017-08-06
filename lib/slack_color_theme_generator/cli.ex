defmodule SlackColorThemeGenerator.CLI do
  def main(args) do
    args
    |> Enum.map(&SlackColorThemeGenerator.generate/1)
  end
end
