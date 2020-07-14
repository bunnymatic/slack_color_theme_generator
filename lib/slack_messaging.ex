defmodule SlackMessaging do
  def error_message do
    [
      "And what am I supposed to do with that?",
      "¯\\_(ツ)_/¯",
      "Nice try.",
      "Eh?",
      "Sometimes animated GIFs don't agree with my delicate disposition.",
      "You call that a picture?"
    ]
    |> Enum.random()
  end

  def color_name_message(nil), do: color_name_message()
  def color_name_message(""), do: color_name_message()
  def color_name_message(<<h, c::binary>>) when h in ' \t\n\r', do: color_name_message(c)
  def color_name_message(color) do
    msg_fn =
      [
        &"I think that should be called '#{&1}'.",
        &"Feels like maybe '#{&1}'.",
        &"What about '#{&1}'?",
        &"That's my favorite color, '#{&1}'!",
        &"I'd call that '#{&1}'."
      ]
      |> Enum.random()

    msg_fn.(color)
  end

  def color_name_message() do
    [
      "I have no idea what I'd call that.",
      "I got nothing.",
      "Are you sure that's a color?",
      "Is this a color that only dogs can see?"
    ]
    |> Enum.random()
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
