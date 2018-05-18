defmodule Color do
  @moduledoc """
  Color Helper Methods
  """

  require Logger

  use Inspector

  defstruct red: 0, green: 0, blue: 0, alpha: 255, hex: ""

  @doc """
  return perceptive lightness for a color
  """
  def perceptive_lightness(%Color{red: red, blue: blue, green: green, alpha: alpha}) do
    (0.299*red + 0.587*green + 0.114*blue) * alpha/255.0
  end

  def perceptive_lightness(color = %{"red" => _r, "blue" => _b, "green" => _g}) do
    color
    |> atomize_keys
    |> color_struct_from_map
    |> perceptive_lightness
  end

  def perceptive_lightness(hex) when (byte_size(hex) == 6 or byte_size(hex) == 8) do
    hex
    |> split_hexstring_into_colors
    |> color_struct_from_map
    |> perceptive_lightness
  end

  def perceptive_lightness("#" <> hex), do: hex |> perceptive_lightness
  def perceptive_lightness(_), do: %Color{} |> perceptive_lightness


  defp split_hexstring_into_colors(hex) when (byte_size(hex) == 8) or (byte_size(hex) == 6) do
    [[ :red, :green, :blue, :alpha ],
     hex
     |> split_string_into_char_pairs
     |> Enum.map(&hex_to_color/1)
    ]
    |> List.zip
    |> Map.new
  end

  defp split_string_into_char_pairs(str) do
    str
    |> String.codepoints
    |> Enum.chunk(2)
    |> Enum.map(&Enum.join/1)
  end

  defp hex_to_color(hex) do
    hex
    |> Integer.parse(16)
    |> case do
         { value, "" } -> value
         { _, :error } -> 0
         _ -> 0
       end
  end

  defp atomize_keys(map), do: map |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

  defp color_struct_from_map(map), do: struct(Color, map)

end
