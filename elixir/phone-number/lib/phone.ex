defmodule Phone do
  @invalid "0000000000"

  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t()) :: String.t()
  def number(raw), do: process(raw)

  def process(raw) do
    num = clean(raw)
    num = country(num)
    num = area(num)
    num = exchange(num)
  end

  def country(<<"1", rest::binary-size(10)>>), do: rest
  def country(<<rest::binary-size(10)>>), do: rest
  def country(_), do: @invalid

  def area(<<"0", rest::binary>>), do: @invalid
  def area(<<"1", rest::binary>>), do: @invalid
  def area(num), do: num

  def exchange(<<_::binary-size(3), "0", rest::binary>>), do: @invalid
  def exchange(<<_::binary-size(3), "1", rest::binary>>), do: @invalid
  def exchange(num), do: num

  @spec clean(String.t()) :: String.t()
  def clean(raw) do
    num = String.replace(raw, ["+", "(", ")", "-", ".", " "], "")
    try do
      String.to_integer(num)
    rescue
      ArgumentError -> @invalid
    else
      _ -> num
    end
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t()) :: String.t()
  def area_code(raw), do: String.slice(process(raw), 0..2)

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t()) :: String.t()
  def pretty(raw) do
    <<area::binary-size(3), exchange::binary-size(3), subscriber::binary-size(4)>> = number(raw)
    "(#{area}) #{exchange}-#{subscriber}"
  end
end
