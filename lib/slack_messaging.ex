defmodule SlackMessaging do
  def error_message do
    [
      "And what am I supposed to do with that?",
      "¯\\_(ツ)_/¯",
      "Nice try.",
      "Eh?",
      "Sometimes animated GIFs don't agree with my delicate disposition.",
      "You call that a picture?",
      "I got nothin'."
    ]
    |> Enum.random()
  end

  # def color_name_message(nil), do: color_name_message()
  # def color_name_message(""), do: color_name_message()
  # def color_name_message(<<h, c::binary>>) when h in ' \t\n\r', do: color_name_message(c)

  def color_name_message(_entry = %{color: color, name: nil}), do: color_name_message(color)
  def color_name_message(_entry = %{color: color, name: ""}), do: color_name_message(color)
  def color_name_message(_entry = %{color: color, name: name}) do
    msg_fn =
      [
        &"I think that #{&1} should be called '#{&2}'.",
        &"#{&1} feels like maybe '#{&2}'.",
        &"What about '#{&2}' for #{&1}?",
        &"#{&1} is totally my favorite color, '#{&2}'!",
        &"I'd call #{&1} '#{&2}'."
      ]
      |> Enum.random()

    msg_fn.(color, name)
  end

  def color_name_message(color) do
    msg_fn = [
      &"I have no idea what I'd call #{&1}.",
      &"I got nothing for #{&1}.",
      &"Are you sure #{&1} is a color?",
      &"Is #{&1} a color that only dogs can see?"
    ]
    |> Enum.random()
    msg_fn.(color)
  end

  def theme_message do
    [
      "Awesome :thumbsup:",
      "Great idea! :cloud:",
      "Color me dazzled! :coffee:",
      "A regular Leonardo :paw_prints:",
      "Look out, Rauschenberg :space_invader:",
      "You're a natural designer! :lower_left_paintbrush:",
      "Theme it up! :cat2:",
      "That picture is super! :smile_cat:",
      "You rule the school! :footprints:",
      "So good! :100:",
      "Hot! :thermometer:"
    ]
    |> Enum.random()
  end
end
