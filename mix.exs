defmodule CrunchBerry.MixProject do
  use Mix.Project

  def project do
    [
      app: :crunch_berry,
      version: "0.4.2",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      config_path: "./config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
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
      # Phoenix
      {:phoenix_live_view, ">= 0.18.2"},
      {:phoenix_html, ">= 3.0.0"},

      # Utils
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:timex, "~> 3.7"},
      {:jason, "~> 1.2", only: [:dev, :test]},

      # Test helpers
      {:floki, ">= 0.30.0", only: :test},
      {:excoveralls, "~> 0.13", only: :test},
      {:junit_formatter, "~> 3.1", only: :test},

      # Static analysis
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo_contrib, "~> 0.2", only: [:dev, :test], runtime: false},
      {:credo_envvar, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 2.0", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.12", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false}
    ]
  end
end
