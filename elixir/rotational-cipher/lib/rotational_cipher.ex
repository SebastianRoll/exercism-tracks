defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    String.to_charlist(text)
    |> Enum.map(& rot(&1, shift))
    |> List.to_string()
  end

  def rot(char, shift) do
    case char do
      x when x >= ?a and x <= ?z -> ?a + Kernel.rem(x-?a+shift, 26)
      x when x >= ?A and x <= ?Z -> ?A + Kernel.rem(x-?A+shift, 26)
      x -> x
    end
  end
end
