# pokedex-etl

Command-line tool that extracts Pokémon data from [pokedex-gql](https://github.com/michaelmaysonet74/pokedex-gql), transforms it for consistency, and loads it into a PostgreSQL database.

## Getting Started

### Requirements

- Elixir `v1.18.0`

- PostgreSQL `v17.6`

### Usage

Install dependencies:

```sh
mix deps.get
```

Compile:

```sh
mix escript.build
```

Run:

```sh
./pokedex_etl ingest --gen=1
```
