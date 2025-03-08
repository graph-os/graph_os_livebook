defmodule GraphOS.Livebook.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/graph-os/graph_os_livebook"

  def project do
    [
      app: :graph_os_livebook,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex package info
      description: "Livebook integration for GraphOS umbrella visualization",
      package: package(),
      docs: docs(),
      name: "GraphOS.Livebook"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GraphOS.Livebook.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # GraphOS dependencies
      {:graph_os_core, in_umbrella: true},
      {:graph_os_graph, in_umbrella: true},
      {:graph_os_mcp, in_umbrella: true},

      # Livebook related dependencies
      {:kino, "~> 0.11.3"},
      {:vega_lite, "~> 0.1.8"},
      {:kino_vega_lite, "~> 0.1.10"},

      # Development dependencies
      {:ex_doc, "~> 0.29", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["GraphOS Team"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp docs do
    [
      main: "GraphOS.Livebook",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
