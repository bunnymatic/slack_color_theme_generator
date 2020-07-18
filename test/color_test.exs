defmodule ColorTest do
  use ExUnit.Case, async: true
  doctest Color

  test ".perceptive_lightness with anything else returns 0" do
    assert "" |> Color.perceptive_lightness() == 0
  end

  test ".perceptive_lightness with a 6 characer hex color string prepended by # computes the lightness" do
    assert_in_delta "#808080" |> Color.perceptive_lightness(), 128, 0.01
  end

  test ".perceptive_lightness with a 8 characer hex color string prepended by # computes the lightness" do
    assert_in_delta "#808080ff" |> Color.perceptive_lightness(), 128, 0.01
  end

  test ".perceptive_lightness with a 6 character hex color string computes the lightness" do
    assert_in_delta "ff0000" |> Color.perceptive_lightness(), 76.25, 0.01
  end

  test ".perceptive_lightness with an 8 character hex color string computes the lightness" do
    assert_in_delta "ff0000FF" |> Color.perceptive_lightness(), 76.25, 0.01
  end

  test ".perceptive_lightness with an invalid 6 character hex color string returns 0" do
    assert "who_me" |> Color.perceptive_lightness() == 0
  end

  test ".perceptive_lightness with %Color struct and one color set computes the lightness" do
    assert_in_delta %Color{red: 255} |> Color.perceptive_lightness(), 76.25, 0.01
  end

  test ".perceptive_lightness with map with string keys red, green and blue computes the lightness" do
    assert_in_delta %{"red" => 255, "blue" => 0, "green" => 0} |> Color.perceptive_lightness(),
                    76.25,
                    0.01
  end
end
