defmodule Year do
  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      unless the year is also evenly divisible by 400
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year) do
    cond1?(year)
  end

  defp cond1?(year) when (year/4)==div(year, 4) do
    cond2?(year)
  end
  defp cond1?(year) do
    false
  end

  defp cond2?(year) when (year/100)==div(year, 100) do
    cond3?(year)
  end
  defp cond2?(year) do
    true
  end

  defp cond3?(year) when (year/400)==div(year, 400) do
    true
  end
  defp cond3?(year) do
    false
  end
end
