import Config

config :pokedex_etl, PokedexETL.Repo,
  database: System.get_env("POKEDEX_DB_NAME", "pokedex"),
  username: System.get_env("POKEDEX_DB_USERNAME", "postgres"),
  password: System.get_env("POKEDEX_DB_PASSWORD", "postgres"),
  hostname: System.get_env("POKEDEX_DB_HOSTNAME", "localhost"),
  port: System.get_env("POKEDEX_DB_PORT", "5432") |> String.to_integer(),
  pool_size: System.get_env("POKEDEX_DB_POOL_SIZE", "10") |> String.to_integer()
