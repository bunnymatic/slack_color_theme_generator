defmodule SlackColorThemeGeneratorTest do

  use ExUnit.Case, async: true
  doctest SlackColorThemeGenerator

  use Inspector

  @fixture Path.join(__DIR__, "fixtures/rainbow.jpg")
  @narrow_fixture Path.join(__DIR__, "fixtures/narrow.png")

  test ".generate returns a slack theme" do
    assert (@fixture |> SlackColorThemeGenerator.generate), "#FFFFFF,#F0CFD6,#F5E805,#D1A6B0,#0EBE0A,#ED341C,#0485DD,#1A0F98"
  end

  test ".generate returns nil if the range is too narrow" do
    (@narrow_fixture |> SlackColorThemeGenerator.generate)  |> inspector
    refute (@narrow_fixture |> SlackColorThemeGenerator.generate)
  end

end
