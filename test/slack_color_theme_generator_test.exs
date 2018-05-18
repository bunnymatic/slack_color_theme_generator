defmodule SlackColorThemeGeneratorTest do

  use ExUnit.Case, async: true
  doctest SlackColorThemeGenerator

  use Inspector

  @fixture Path.join(__DIR__, "fixtures/rainbow.jpg")
  @narrow_fixture Path.join(__DIR__, "fixtures/narrow.png")

  test ".generate returns a v2 theme given the mapping" do
    assert (@fixture |> SlackColorThemeGenerator.generate(:v2)) == "#D1A6B0,#FFFFFF,#F0CFD6,#0EBE0A,#0485DD,#1A0F98,#F5E805,#ED341C"
  end

  test ".generate returns a v1 theme given the mapping" do
    assert (@fixture |> SlackColorThemeGenerator.generate(:v1)) == "#FFFFFF,#0EBE0A,#F5E805,#F0CFD6,#1A0F98,#0485DD,#ED341C,#D1A6B0"
  end

  test ".generate returns a simple sorted slack theme" do
    assert (@fixture |> SlackColorThemeGenerator.generate(:simple_sort)) == "#FFFFFF,#F0CFD6,#F5E805,#D1A6B0,#0EBE0A,#ED341C,#0485DD,#1A0F98"
  end

  test ".generate returns a v1 slack theme by default" do
    assert (@fixture |> SlackColorThemeGenerator.generate) == "#FFFFFF,#0EBE0A,#F5E805,#F0CFD6,#1A0F98,#0485DD,#ED341C,#D1A6B0"
  end

  test ".generate returns nil if the range is too narrow" do
    (@narrow_fixture |> SlackColorThemeGenerator.generate)  |> inspector
    refute (@narrow_fixture |> SlackColorThemeGenerator.generate)
  end

end
