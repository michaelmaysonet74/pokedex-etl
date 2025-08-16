defmodule PokedexETL.Client do
  require Logger

  @query """
    query PokemonById($id: ID!) {
      pokemon: pokemonById(id: $id) {
          id
          name
          entry
          sprite
          immunities
          resistances
          weaknesses
          category
          types
          abilities {
              name
              effect
              is_hidden: isHidden
          }
          measurement {
              height
              weight
          }
          evolution {
              from {
                  id
                  name
              }
              to {
                  id
                  name
              }
          }
          base_stats: baseStats {
              hp
              attack
              defense
              special_attack: specialAttack
              special_defense: specialDefense
              speed
          }
      }
    }
  """

  @query_opts [
    recv_timeout: :infinity,
    timeout: :infinity
  ]

  def get_pokemon_by_id(id) do
    with {:ok, %Neuron.Response{body: %{"data" => %{"pokemon" => pokemon}}}}
         when not is_nil(pokemon) <- Neuron.query(@query, %{id: id}, @query_opts) do
      {:ok, pokemon}
    else
      {_, %Neuron.Response{body: %{"data" => %{"pokemon" => nil}}}} ->
        Logger.error("Not Found: Pokemon ID #{id}")
        {:error, :not_found}

      {:error, _} ->
        Logger.error("Request failed")
        {:error, :request_failed}
    end
  end
end
