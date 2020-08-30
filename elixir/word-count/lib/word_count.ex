defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    Regex.scan(~r/[[:alnum:]-]+/u, sentence)
      |> List.flatten()
      |> Enum.frequencies_by(&String.downcase/1)
  end
end
