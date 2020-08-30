defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    res = _generate(Enum.reverse(coins), [], target)

    case res do
      {:success, chosen} -> {:ok, chosen}
      {:notfound, chosen} -> {:notfound}
      _ -> res
    end
  end
#  defp _generate(coins, chosen, remaining) when remaining == 0 do
#    {:success, chosen}
#  end

  defp _generate(coins, chosen, remaining) do

    res = Enum.reduce_while(coins, {:notfound, []}, fn x, acc ->

      cond do
        elem(acc, 0) == :success ->
          {:halt, acc}
        x == remaining ->
          {:halt, {:success, [x | chosen]}}
        remaining-x >= 0 ->
          {:cont, _generate(coins, [x | chosen], remaining-x)}
        true ->
          {:cont, acc}
          end

      end
    )
  end

end
