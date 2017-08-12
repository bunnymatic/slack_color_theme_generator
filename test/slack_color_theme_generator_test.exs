defmodule SlackColorThemeGeneratorTest do
  import SlackColorThemeGenerator
  use ExUnit.Case, async: true
  doctest SlackColorThemeGenerator

  @fixture Path.join(__DIR__, "fixtures/rainbow.jpg")

  test ".genmerate returns a slack theme" do
    assert (@fixture |> SlackColorThemeGenerator.generate), "#FFFFFF,#F0CFD6,#F5E805,#D1A6B0,#0EBE0A,#ED341C,#0485DD,#1A0F98"
  end
end
