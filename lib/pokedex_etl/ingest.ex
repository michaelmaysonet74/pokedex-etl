defmodule PokedexETL.Ingest do
  require Logger
  alias PokedexETL.Client
  alias PokedexETL.Repo
  alias PokedexSchema.Pokemon

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

  def run(gen) do
    case @generations[gen] do
      nil ->
        {:error, :invalid_input}

      ids ->
        inserted_count = ingest_pokemon_by_ids(ids)
        {:ok, "Inserted #{inserted_count} Pokemon from generation #{gen}."}
    end
  end

  defp ingest_pokemon_by_ids(ids) do
    ids
    |> Task.async_stream(&process_pokemon_id/1, ordered: true)
    |> Enum.count(&match?({:ok, :ok}, &1))
  end

  defp process_pokemon_id(id) do
    with {:ok, pokemon} <- Client.get_pokemon_by_id(id),
         {:ok, _} <- insert_pokemon(pokemon) do
      :ok
    else
      error ->
        Logger.error("Failed to insert Pokémon #{id}: #{inspect(error)}")
        :error
    end
  end

  defp insert_pokemon(pokemon) do
    %Pokemon{}
    |> Pokemon.changeset(pokemon)
    |> Repo.insert()
  end
end
