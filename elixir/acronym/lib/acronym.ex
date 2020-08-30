defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    words = string
      |> String.replace(~r/_|-|,|'/u, "")
      |> String.split()
      |> Enum.reduce("", fn w, acc -> acc <> acronyms(w) end)
    words
  end

  @doc """
  Returns acronym letters. First letter in word and following capitalized letters
  which are not preceeded by a capitalized letter.
  "HyperText" -> "HT
  "Markup" -> "M"
  """
  def acronyms(word) do
    rest = String.slice(word, 1..-1)
    String.capitalize(String.first(word)) <> acronyms(rest, true)
  end

  def acronyms("", _prev_capitalized) do
    ""
  end

  def acronyms(word, false) do
    rest = String.slice(word, 1..-1)
    letter = String.first(word)
    case String.capitalize(letter) == letter do
      true -> String.capitalize(letter) <> acronyms(rest, true)
      false -> acronyms(rest, false)
      end
  end

  def acronyms(word, true) do
    rest = String.slice(word, 1..-1)
    letter = String.first(word)
    case String.capitalize(letter) == letter do
      true -> acronyms(rest, true)
      false -> acronyms(rest, false)
      end
  end
end
