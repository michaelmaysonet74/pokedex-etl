defmodule PokedexETL.Ingest do
  alias PokedexETL.Client

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

      generation ->
        result = generation |> Task.async_stream(&fetch_and_insert_pokemon/1) |> Enum.count()
        {:ok, "Inserted #{result} Pokemon from generation #{gen}."}
    end
  end

  defp fetch_and_insert_pokemon(id) do
    Client.get_pokemon_by_id(id) |> IO.inspect()
  end
end
