defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep([head|tail], fun) do
    first = fun.(head)
    case first do
      true -> [head|Strain.keep(tail, fun)]
      _ -> Strain.keep(tail, fun)
    end
  end

  def keep([], _fun) do
    []
    end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    list -- Strain.keep(list, fun)
  end

end
