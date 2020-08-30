defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """

  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    to_roman(number, "")
  end

  def to_roman(number, roman) when div(number, 1000) != 0 do
    to_roman(number-1000, roman <> "M")
  end
  def to_roman(number, roman) when div(number, 900) != 0 do
    to_roman(number-900, roman <> "CM")
  end


  def to_roman(number, roman) when div(number, 500) != 0 do
    to_roman(number-500, roman <> "D")
  end
  def to_roman(number, roman) when div(number, 400) != 0 do
    to_roman(number-400, roman <> "CD")
  end

  def to_roman(number, roman) when div(number, 100) != 0 do
    to_roman(number-100, roman <> "C")
  end
  def to_roman(number, roman) when div(number, 90) != 0 do
    to_roman(number-90, roman <> "XC")
  end

  def to_roman(number, roman) when div(number, 50) != 0 do
    to_roman(number-50, roman <> "L")
  end
  def to_roman(number, roman) when div(number, 40) != 0 do
    to_roman(number-40, roman <> "XL")
  end

  def to_roman(number, roman) when div(number, 10) != 0 do
    to_roman(number-10, roman <> "X")
  end
  def to_roman(number, roman) when div(number, 9) != 0 do
    to_roman(number-9, roman <> "IX")
  end

  def to_roman(number, roman) when div(number, 5) != 0 do
    to_roman(number-5, roman <> "V")
  end
  def to_roman(number, roman) when div(number, 4) != 0 do
    to_roman(number-4, roman <> "IV")
  end

  def to_roman(number, roman) when div(number, 1) != 0  do
    to_roman(number-1, roman <> "I")
  end
  def to_roman(0, roman) do
    roman
  end
end
