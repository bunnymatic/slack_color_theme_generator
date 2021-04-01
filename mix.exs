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
      {:briefly, "~> 0.3"},
      {:download, "~> 0.0.4"},
      {:hackney, "~> 1.17.4"},
      {:jason, ">= 1.0.0"},
      {:mogrify, git: "https://github.com/route/mogrify.git"},
      {:poison, ">= 1.0.0"},
      {:slack, "~> 0.23.0"},
      {:tesla, "~> 1.4.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
