defmodule ResistorColor do
  @moduledoc false

  def colormap() do
    [
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  ]
  end

  @spec colors() :: list(String.t())
  def colors do
    Keyword.keys(ResistorColor.colormap()) |> Enum.map(& Atom.to_string(&1))
  end

  @spec code(String.t()) :: integer()
  def code(color) do
    ResistorColor.colormap()[String.to_atom(color)]
  end
end
