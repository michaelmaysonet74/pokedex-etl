defmodule PokedexETL.MixProject do
  use Mix.Project

  def project do
    [
      app: :pokedex_etl,
      version: "0.1.0",
      elixir: "~> 1.18",
      escript: [main_module: PokedexETL.CLI],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {PokedexETL.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.11"},
      {:postgrex, ">= 0.0.0"},
      {:neuron, "~> 5.1"},
      {:jason, "~> 1.4"},
      {:pokedex_schema,
       git: "https://github.com/michaelmaysonet74/pokedex-schema.git", tag: "v0.1.0"}
    ]
  end
end
