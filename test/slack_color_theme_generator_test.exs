defmodule SlackColorThemeGeneratorTest do
  use ExUnit.Case, async: true
  doctest SlackColorThemeGenerator

  @fixture Path.join(__DIR__, "fixtures/rainbow.jpg")
  @anim_fixture Path.join(__DIR__, "fixtures/anim.gif")
  @narrow_fixture Path.join(__DIR__, "fixtures/narrow.png")

  test ".generate returns a v2 theme given the mapping" do
    assert @fixture |> SlackColorThemeGenerator.generate(:v2) ==
             "#D1A6B0,#FFFFFF,#F0CFD6,#0EBE0A,#0485DD,#1A0F98,#F5E805,#ED341C"
  end

  test ".generate returns a v1 theme given the mapping" do
    assert @fixture |> SlackColorThemeGenerator.generate(:v1) ==
             "#FFFFFF,#0EBE0A,#F5E805,#F0CFD6,#1A0F98,#0485DD,#ED341C,#D1A6B0"
  end

  test ".generate returns a simple sorted slack theme" do
    assert @fixture |> SlackColorThemeGenerator.generate(:simple_sort) ==
             "#FFFFFF,#F0CFD6,#F5E805,#D1A6B0,#0EBE0A,#ED341C,#0485DD,#1A0F98"
  end

  test ".generate returns a v1 slack theme by default" do
    assert @fixture |> SlackColorThemeGenerator.generate() ==
             "#FFFFFF,#0EBE0A,#F5E805,#F0CFD6,#1A0F98,#0485DD,#ED341C,#D1A6B0"
  end

  test ".generate returns nil if the range is too narrow" do
    refute @narrow_fixture |> SlackColorThemeGenerator.generate()
  end

  test ".generates the right histogram for a multiframe gif" do
    assert @anim_fixture |> SlackColorThemeGenerator.generate() ==
             "#D6B18E,#7B8D91,#CDA275,#C2AF9D,#250F09,#663522,#9D6041,#B38E67"
  end
end
