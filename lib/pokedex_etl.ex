defmodule PokedexETL do
  alias PokedexETL.Ingest

  def main(["ingest", "--gen=" <> gen]) do
    Application.ensure_all_started(:pokedex_etl)
    ingest(gen)
  end

  def main(_), do: usage()

  defp ingest(gen) do
    case Ingest.run(gen) do
      {:ok, result} -> IO.puts(result)
      _ -> IO.puts("Invalid Input: --gen=#{gen}")
    end
  end

  defp usage do
    IO.puts("""
    Usage:
      pokedex_etl ingest --gen=<number>
    """)
  end
end
