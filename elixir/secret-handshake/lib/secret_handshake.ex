defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  use Bitwise

  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    ret = []
    op = case code &&& 16 do
      16 -> fn list, val -> [val] ++ list end
      _ -> fn list, val -> list ++ [val] end
    end

    ret = if (code &&& 1) == 1, do: op.(ret, "wink"), else: ret
    ret = if (code &&& 2) == 2, do: op.(ret, "double blink"), else: ret
    ret = if (code &&& 4) == 4, do: op.(ret, "close your eyes"), else: ret
    ret = if (code &&& 8) == 8, do: op.(ret, "jump"), else: ret
    ret
  end
end
