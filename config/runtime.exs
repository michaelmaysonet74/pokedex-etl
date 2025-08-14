import Config

config :pokedex_etl,
  client_url: System.get_env("POKEDEX_GQL_URL", "http://localhost:4000/graphql")
