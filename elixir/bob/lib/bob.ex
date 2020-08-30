defmodule Bob do
  def hey(input) do
    input = String.trim_trailing(input)
    no_downcase = String.upcase(input) == input
    has_alpha = String.upcase(input) != String.downcase(input)
    is_question = String.last(input) == "?"

    cond do
      input  == "" -> "Fine. Be that way!"
      no_downcase && has_alpha && is_question -> "Calm down, I know what I'm doing!"
      no_downcase && has_alpha -> "Whoa, chill out!"
      is_question -> "Sure."
      true -> "Whatever."
    end
  end
end
