defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when is_integer(number) and number > 0 and number <= 64 do
    {:ok, trunc(:math.pow(2, number-1))}
  end
  def square(number) do
    {:error, "The requested square must be between 1 and 64 (inclusive)"}
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
  {:ok, _total(64, 0)}
  end

  @spec total :: pos_integer
  defp _total(0, sum), do: sum
  defp _total(cur_square, sum) do
    {:ok, grains} = square(cur_square)
    _total(cur_square-1, sum+grains)
  end
end
