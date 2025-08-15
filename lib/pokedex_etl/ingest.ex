defmodule PokedexETL.Ingest do
  alias PokedexETL.Client
  alias PokedexETL.Repo
  alias PokedexSchema.Pokemon

  require Logger

  @async_opts [
    max_concurrency: 5,
    ordered: true,
    timeout: :infinity
  ]

  @batch_size 25

  @generations %{
    "1" => 1..151,
    "2" => 152..251,
    "3" => 252..386,
    "4" => 387..493,
    "5" => 494..649,
    "6" => 650..721,
    "7" => 722..809,
    "8" => 810..905,
    "9" => 906..1025
  }

  def run(gen) when is_map_key(@generations, gen) do
    @generations[gen]
    |> Enum.chunk_every(@batch_size)
    |> Enum.each(fn batch -> process_batch(batch, gen) end)

    {:ok, "Done"}
  end

  def run(_), do: {:error, :invalid_input}

  defp process_batch(batch, gen) do
    batch
    |> Task.async_stream(
      fn id ->
        with {:ok, pokemon} <- extract(id),
             {:ok, updated_pokemon} <- transform(pokemon, gen),
             _ <- load(updated_pokemon),
             do: :ok
      end,
      @async_opts
    )
    |> Stream.run()
  end

  defp extract(id), do: Client.get_pokemon_by_id(id)

  defp transform(pokemon, gen) do
    evolution = pokemon["evolution"] || %{}

    updated_evolution =
      Map.merge(evolution, %{
        "from" => evolution["from"] || %{},
        "to" => evolution["to"] || []
      })

    {:ok, Map.merge(pokemon, %{"evolution" => updated_evolution, "generation" => gen})}
  end

  defp load(pokemon), do: %Pokemon{} |> Pokemon.changeset(pokemon) |> Repo.insert()
end
