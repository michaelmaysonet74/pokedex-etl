defmodule PokedexETL.Client do
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
              total
          }
      }
    }
  """

  def get_pokemon_by_id(id) do
    with {:ok, %Neuron.Response{body: %{"data" => data}}} <-
           Neuron.query(@query, %{id: id}, url: Application.get_env(:pokedex_etl, :client_url)) do
      {:ok, data["pokemon"]}
    else
      _ -> {:error, :not_found}
    end
  end
end
