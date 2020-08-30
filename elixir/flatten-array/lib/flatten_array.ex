defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list) do
    _flatten(list, [])
  end

  def _flatten([hd|tl], flat) when is_list(hd) do
    _flatten(tl, _flatten(hd, flat))
  end

  def _flatten([hd|tl], flat) when hd == nil do
    _flatten(tl, flat)
  end

  def _flatten([hd|tl], flat) do
    _flatten(tl, flat ++ [hd])
  end

  def _flatten(el, flat) do
    flat
  end
end
