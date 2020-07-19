defmodule SlackMessagingTest do
  use ExUnit.Case, async: true
  doctest SlackMessaging

  test ".error_message/0 returns something" do
    assert SlackMessaging.error_message()
  end

  test ".color_name_message/0 returns something" do
    assert SlackMessaging.color_name_message
  end

  test ".color_name_message/1 with nil/empty returns something" do
    assert SlackMessaging.color_name_message(nil)
    assert SlackMessaging.color_name_message("")
    refute ~r/\s{3}/ |> Regex.match?(SlackMessaging.color_name_message("    "))
  end

  test ".color_name_message/1 with string returns message with that string in it" do
    assert ~r/whatever/ |> Regex.match?(SlackMessaging.color_name_message("whatever"))
  end


end
