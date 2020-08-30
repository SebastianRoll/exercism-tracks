defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    Map.to_list(input)
      |> Enum.reduce(%{}, fn words, acc -> add_words(words, acc) end)
  end

  @spec add_words(tuple, map) :: map
  defp add_words({point, words}, output) do
    Enum.reduce(words, output, fn word, acc -> Map.put(acc, String.downcase(word), point) end)
  end
end
