defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    String.split(m, "\n")
      |> Enum.map_join(&process/1)
      |> enclose_list()
  end

  defp process(<<"* ", rest::binary>>) do
    "<li>" <> join_words_with_tags(rest) <> "</li>"
  end

  defp process(<<"#", rest::binary>>) do
    process_header(rest, 1)
  end

  defp process(rest) do
    "<p>#{join_words_with_tags(rest)}</p>"
  end

  defp process_header(<<"#", rest::binary>>, count) do
    process_header(rest, count+1)
  end

  defp process_header(rest, count) do
    "<h#{count}>" <> join_words_with_tags(rest) <> "</h#{count}>"
  end

  defp join_words_with_tags(t) do
    String.split(t)
      |> Enum.map_join(" ", &replace_md_with_tag/1)
  end

  defp replace_md_with_tag(w) do
    replace_prefix_md(w)
      |> replace_suffix_md()
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^#{"__"}{1}/ -> String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
      w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(w, ~r/_/, "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
      w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end

  defp enclose_list(l) do
    String.replace(l, "<li>", "<ul>" <> "<li>", global: false)
      |> String.replace_suffix("</li>", "</li>" <> "</ul>")
  end
end
