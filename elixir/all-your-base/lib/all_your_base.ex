defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list | nil
  def convert(digits, base_a, base_b) do
    _convert(digits, base_a, base_b, 0)
#    (4 * 10^1) + (2 * 10^0)
#    The number 101010, in base 2, means:
#    (1 * 2^5) + (0 * 2^4) + (1 * 2^3) + (0 * 2^2) + (1 * 2^1) + (0 * 2^0)
#    The number 1120, in base 3, means:
#    (1 * 3^3) + (1 * 3^2) + (2 * 3^1) + (0 * 3^0)
  end
  def _convert([hd|tl], base_a, base_b, new) do
    val_a = hd*:math.pow(base_a,length(tl))
    val_b = val_a / :math.pow(base_b,length(tl))
#    IO.inspect("hd")
#    IO.inspect(hd)
#    IO.inspect(val_a)
#    IO.inspect(val_b)
#    _convert(tl, base_a, base_b, [hd*:math.pow(base_a,length(tl)) | new])
    a = _convert(tl, base_a, base_b, hd*:math.pow(base_a,length(tl)) + new)

  end
  def con(val, base_b, new, count) do

  end
  def _convert([], base_a, base_b, new) do
    new
  end
end
