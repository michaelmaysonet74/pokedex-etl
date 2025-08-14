defmodule PokedexETL.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # PokedexETL.Repo
    ]

    opts = [strategy: :one_for_one, name: PokedexETL.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
