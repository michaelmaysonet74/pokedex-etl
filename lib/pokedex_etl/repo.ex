defmodule PokedexETL.Repo do
  use Ecto.Repo,
    otp_app: :pokedex_etl,
    adapter: Ecto.Adapters.Postgres
end
