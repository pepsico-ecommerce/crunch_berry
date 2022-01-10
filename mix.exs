defmodule CrunchBerry.MixProject do
  use Mix.Project

  def project do
    [
      app: :crunch_berry,
      version: "0.2.7",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      config_path: "./config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, ">= 0.16.1"},
      {:phoenix_html, ">= 3.0.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:jason, "~> 1.2", only: [:dev, :test]},
      {:floki, ">= 0.30.0", only: :test},
      {:timex, "~> 3.7"}
    ]
  end
end
