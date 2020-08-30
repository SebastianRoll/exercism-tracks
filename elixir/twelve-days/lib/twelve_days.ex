defmodule TwelveDays do

  @spec ordinalize(number :: integer) :: String.t()
  def ordinalize(1), do: "first"
  def ordinalize(2), do: "second"
  def ordinalize(3), do: "third"
  def ordinalize(4), do: "fourth"
  def ordinalize(5), do: "fifth"
  def ordinalize(6), do: "sixth"
  def ordinalize(7), do: "seventh"
  def ordinalize(8), do: "eighth"
  def ordinalize(9), do: "ninth"
  def ordinalize(10), do: "tenth"
  def ordinalize(11), do: "eleventh"
  def ordinalize(12), do: "twelfth"

  def gift(num=1, acc)do
    case acc do
      "" -> "a Partridge in a Pear Tree"
      _ -> "and a Partridge in a Pear Tree"
      end
    end
  def gift(num=2, acc), do: "two Turtle Doves, "
  def gift(num=3, acc), do: "three French Hens, "
  def gift(num=4, acc), do: "four Calling Birds, "
  def gift(num=5, acc), do: "five Gold Rings, "
  def gift(num=5, acc), do: "five Gold Rings, "
  def gift(num=6, acc), do: "six Geese-a-Laying, "
  def gift(num=7, acc), do: "seven Swans-a-Swimming, "
  def gift(num=8, acc), do: "eight Maids-a-Milking, "
  def gift(num=9, acc), do: "nine Ladies Dancing, "
  def gift(num=10, acc), do: "ten Lords-a-Leaping, "
  def gift(num=11, acc), do: "eleven Pipers Piping, "
  def gift(num=12, acc), do: "twelve Drummers Drumming, "

  def gifts(num=0, acc), do: acc
  def gifts(num, acc), do: gifts(num-1,  acc <> TwelveDays.gift(num, acc))

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    "On the #{ordinalize(number)} day of Christmas my true love gave to me: " <> gifts(number, "") <> "."
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse..ending_verse
      |> Enum.map(&verse/1)
      |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end
end
