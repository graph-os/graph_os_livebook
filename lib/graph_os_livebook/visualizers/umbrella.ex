defmodule GraphOS.Livebook.Visualizers.Umbrella do
  @moduledoc """
  Provides visualization tools for the GraphOS umbrella application structure.
  """

  alias VegaLite, as: Vl

  @doc """
  Generates a visualization of the umbrella application structure.

  Returns a Vega-Lite specification that can be rendered in Livebook.
  """
  def visualize do
    apps = [
      %{id: "graph_os_umbrella", type: "umbrella", level: 1},
      %{id: "graph_os_core", type: "app", level: 2, parent: "graph_os_umbrella"},
      %{id: "graph_os_graph", type: "app", level: 2, parent: "graph_os_umbrella"},
      %{id: "graph_os_mcp", type: "app", level: 2, parent: "graph_os_umbrella"},
      %{id: "graph_os_livebook", type: "app", level: 2, parent: "graph_os_umbrella"}
    ]

    links = [
      %{source: "graph_os_umbrella", target: "graph_os_core"},
      %{source: "graph_os_umbrella", target: "graph_os_graph"},
      %{source: "graph_os_umbrella", target: "graph_os_mcp"},
      %{source: "graph_os_umbrella", target: "graph_os_livebook"},
      %{source: "graph_os_livebook", target: "graph_os_core"},
      %{source: "graph_os_livebook", target: "graph_os_graph"},
      %{source: "graph_os_livebook", target: "graph_os_mcp"},
      %{source: "graph_os_core", target: "graph_os_graph"},
      %{source: "graph_os_mcp", target: "graph_os_graph"}
    ]

    Vl.new(width: 800, height: 500)
    |> Vl.data_from_values(apps, name: "apps")
    |> Vl.data_from_values(links, name: "links")
    |> Vl.resolve(:scale, color: :independent)
    |> Vl.concat([
      build_node_chart(),
      build_links_chart()
    ], :overlay)
  end

  defp build_node_chart do
    Vl.new()
    |> Vl.data(name: "apps")
    |> Vl.mark(:circle, size: 300, opacity: 0.8)
    |> Vl.encode_field(:x, "id", type: :nominal, title: nil)
    |> Vl.encode_field(:y, "level", type: :ordinal, title: nil)
    |> Vl.encode_field(:color, "type",
        type: :nominal,
        scale: %{
          domain: ["umbrella", "app"],
          range: ["#1f77b4", "#ff7f0e"]
        },
        legend: %{title: "Component Type"}
      )
    |> Vl.encode_field(:tooltip, "id", type: :nominal, title: "Component")
  end

  defp build_links_chart do
    Vl.new()
    |> Vl.data(name: "links")
    |> Vl.mark(:line, opacity: 0.5, interpolate: :bundle)
    |> Vl.encode_field(:x, "source", type: :nominal, title: nil)
    |> Vl.encode_field(:x2, "target", type: :nominal)
    |> Vl.encode_field(:y,
        "source",
        type: :ordinal,
        scale: nil,
        band: 0.5,
        title: nil
      )
    |> Vl.encode_field(:y2,
        "target",
        type: :ordinal,
        scale: nil,
        band: 0.5
      )
  end

  @doc """
  Creates a Livebook notebook that visualizes the GraphOS umbrella application structure.
  """
  def create_notebook do
    %{
      cells: [
        %{
          type: :markdown,
          content: """
          # GraphOS Umbrella Application Visualization

          This notebook visualizes the structure of the GraphOS umbrella application.
          """
        },
        %{
          type: :elixir,
          content: """
          Mix.install([
            {:graph_os_livebook, "~> 0.1.0"},
            {:kino, "~> 0.11.3"},
            {:vega_lite, "~> 0.1.8"},
            {:kino_vega_lite, "~> 0.1.10"}
          ])

          alias GraphOS.Livebook.Visualizers.Umbrella
          """
        },
        %{
          type: :elixir,
          content: """
          Umbrella.visualize()
          |> Kino.VegaLite.new()
          """
        }
      ]
    }
  end
end
