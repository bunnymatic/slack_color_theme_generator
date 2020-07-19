defmodule SlackColorThemeGenerator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :slack_color_theme_generator,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: SlackColorThemeGenerator.CLI],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SlackColorThemeGenerator.App, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mogrify, "~> 0.7.3"},
      {:slack, "~> 0.12.0"},
      {:download, "~> 0.0.4"},
      {:tesla, "~> 1.3.3"},
      {:poison, ">= 1.0.0"},
      {:briefly, "~> 0.3"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
