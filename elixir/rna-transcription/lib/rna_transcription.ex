defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(rna) do
    rna
    |> Enum.map(&do_rna/1)
  end

  @spec do_rna(char) :: char
  defp do_rna(c) do
    case c do
      ?G -> ?C
      ?C -> ?G
      ?T -> ?A
      ?A -> ?U
      end
  end
end
