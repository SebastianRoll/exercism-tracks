defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec bottles(integer) :: String.t()
  def bottles(-1), do: "99 bottles"
  def bottles(0), do: "no more bottles"
  def bottles(1), do: "1 bottle"
  def bottles(number), do: "#{number} bottles"

  @spec action(integer) :: String.t()
  def action(0), do: "Go to the store and buy some more"
  def action(1), do: "Take it down and pass it around"
  def action(_), do: "Take one down and pass it around"

  @spec verse(integer) :: String.t()
  def verse(number) do
      "#{String.capitalize(bottles(number))} of beer on the wall, #{bottles(number)} of beer.\n#{action(number)}, #{bottles(number-1)} of beer on the wall.\n"
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    range
      |> Enum.map(&verse/1)
      |> Enum.join("\n")
  end
end
