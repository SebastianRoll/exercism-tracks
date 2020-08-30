defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_integer(input) and input > 0 do
    collatz(input, 0)
  end
  def calc(_) do
    raise FunctionClauseError
  end

  def collatz(1, iteration) do
    iteration
  end
  def collatz(input, iteration) when rem(input, 2) == 0 do
    collatz(div(input, 2), iteration+1)
  end
  def collatz(input, iteration) do
    collatz((input*3)+1, iteration+1)
  end
end
