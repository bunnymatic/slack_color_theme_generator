defmodule SlackColorThemeGenerator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :slack_color_theme_generator,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      escript: [main_module: SlackColorThemeGenerator.CLI],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mogrify, github: "rcode5/mogrify", branch: "features/add-histogram-generator"},
      {:slack, "~> 0.12.0"},
      {:download, "~> 0.0.4"},
      {:tesla, "~> 0.7.0"},
      {:poison, ">= 1.0.0"},
      {:briefly, "~> 0.3"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
