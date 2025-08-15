defmodule PokedexETL do
  alias PokedexETL.Ingest

  def main(args) do
    Application.ensure_all_started(:pokedex_etl)

    case args do
      ["ingest", "--gen=" <> gen] -> ingest(gen)
      _ -> usage()
    end
  end

  defp ingest(gen) do
    case Ingest.run(gen) do
      {:ok, result} ->
        IO.puts(result)

      {:error, :invalid_input} ->
        IO.puts("Invalid Input: --gen=#{gen}")
    end
  end

  defp usage do
    IO.puts("""
    Usage:
      pokedex_etl ingest --gen=<number>
    """)
  end
end
