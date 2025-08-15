defmodule PokedexETL.Ingest do
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

      gen_range ->
        inserted_count = fetch_and_insert_pokemon(gen_range)
        {:ok, "Inserted #{inserted_count} Pokemon from generation #{gen}."}
    end
  end

  defp fetch_and_insert_pokemon(gen_range) do
    gen_range
    |> Task.async_stream(
      fn id ->
        with {:ok, pokemon} <- Client.get_pokemon_by_id(id),
             {:ok, _} <- insert_pokemon(pokemon) do
          :ok
        else
          error ->
            IO.warn("Failed to insert Pokémon #{id}: #{inspect(error)}")
            :error
        end
      end,
      ordered: true
    )
    |> Enum.frequencies()
    |> Map.get(:ok, 0)
  end

  defp insert_pokemon(pokemon) do
    %Pokemon{}
    |> Pokemon.changeset(pokemon)
    |> Repo.insert()
  end
end
