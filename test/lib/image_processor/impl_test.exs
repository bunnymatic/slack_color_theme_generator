defmodule ImageProcessorImplTest do
  use ExUnit.Case, async: true
  doctest ImageProcessor.Impl

  @fixture Path.join(__DIR__, "../../fixtures/rainbow.jpg")
  @anim_fixture Path.join(__DIR__, "../../fixtures/anim.gif")
  @narrow_fixture Path.join(__DIR__, "../../fixtures/narrow.png")
  @two_color_fixture Path.join(__DIR__, "../../fixtures/2colors.png")

  test ".compute_theme returns a v2 theme given the mapping" do
    assert @fixture |> ImageProcessor.Impl.compute_theme(:v2) ==
             "#D1A6B0,#FFFFFF,#F0CFD6,#0EBE0A,#0485DD,#1A0F98,#F5E805,#ED341C"
  end

  test ".compute_theme returns a v1 theme given the mapping" do
    assert @fixture |> ImageProcessor.Impl.compute_theme(:v1) ==
             "#FFFFFF,#0EBE0A,#F5E805,#F0CFD6,#1A0F98,#0485DD,#ED341C,#D1A6B0"
  end

  test ".compute_theme returns a simple sorted slack theme" do
    assert @fixture |> ImageProcessor.Impl.compute_theme(:simple_sort) ==
             "#FFFFFF,#F0CFD6,#F5E805,#D1A6B0,#0EBE0A,#ED341C,#0485DD,#1A0F98"
  end

  test ".compute_theme returns a v1 slack theme by default" do
    assert @fixture |> ImageProcessor.Impl.compute_theme() ==
             @fixture |> ImageProcessor.Impl.compute_theme(:v1)
  end

  test ".compute_theme returns nil if the range is too narrow" do
    refute @narrow_fixture |> ImageProcessor.Impl.compute_theme()
  end

  test ".compute_theme returns nil if there aren't enough unique colors" do
    refute @two_color_fixture |> ImageProcessor.Impl.compute_theme()
  end

  test ".compute_themes the right histogram for a multiframe gif" do
    assert @anim_fixture |> ImageProcessor.Impl.compute_theme() ==
             "#D6B18E,#7B8D91,#CDA275,#C2AF9D,#250F09,#663522,#9D6041,#B38E67"
  end
end
