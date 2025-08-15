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
    with {:ok, %Neuron.Response{body: %{"data" => %{"pokemon" => pokemon}}}} <-
           Neuron.query(@query, %{id: id}) do
      {:ok, pokemon}
    else
      {_, %Neuron.Response{body: %{"data" => %{"pokemon" => nil}}}} ->
        {:error, :not_found}

      {:error, _} ->
        {:error, :request_failed}
    end
  end
end
