defmodule Forth do

  @opaque evaluator :: any

  defstruct [
    words: %{},
    stack: []
  ]

  defguardp is_separator(c) when c<=32 or c==5760

  defguardp is_integer_string(c) when c >= 48 and c <= 57

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %__MODULE__{}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    do_eval(ev, s)
  end

  defp do_eval(ev, <<"+", rest::binary>>) do
    newstack = Enum.reduce(ev.stack, fn x, acc -> x + acc end)
    do_eval(%{ev | stack: [newstack]}, rest)
  end

  defp do_eval(ev, <<"-", rest::binary>>) do
    newstack = Enum.reduce(ev.stack, fn x, acc -> x - acc end)
    do_eval(%{ev | stack: [newstack]}, rest)
  end

  defp do_eval(ev, <<"*", rest::binary>>) do
    newstack = Enum.reduce(ev.stack, fn x, acc -> x * acc end)
    do_eval(%{ev | stack: [newstack]}, rest)
  end

  defp do_eval(ev, <<"/", rest::binary>>) do
    newstack = divide(ev.stack)
    do_eval(%{ev | stack: [newstack]}, rest)
  end

  defp do_eval(ev, <<":", rest::binary>>) do
    {ev, rest} = new_word(ev, rest, "")
    do_eval(ev, rest)
  end

  defp do_eval(ev, <<c::utf8, rest::binary>>) when is_separator(c) do
    do_eval(ev, rest)
  end

  defp do_eval(ev, <<c::utf8, rest::binary>>) do
    {ev, rest} = case c do
      _ when is_integer_string(c) -> eval_number(ev, rest, [c])
      _ -> eval_word(ev, rest, [c])
    end
    do_eval(ev, rest)
  end

  defp do_eval(ev, "") do
    ev
  end

  defp divide(stack) when length(stack)==1, do: raise Forth.DivisionByZero

  defp divide(stack) do
    Enum.reduce(stack, fn x, acc -> Integer.floor_div(x, acc) end)
  end

  defp eval_number(ev, <<num::utf8, rest::binary>>, number) when is_integer_string(num) do
    eval_number(ev, rest, [num | number])
  end
  defp eval_number(ev, rest, number) do
    number = String.reverse(List.to_string(number))
    {number, _} = Integer.parse(number)
    ev = %{ev | stack: [number | ev.stack]}
    {ev, rest}
  end

  defp new_word(ev, <<";", rest::binary>>, new) do
    [word, definition] = new
      |> List.to_string()
      |> String.reverse()
      |> String.upcase()
      |> String.trim()
      |> String.split(" ", parts: 2)
    ev = do_new_word(ev, word, definition)
    {ev, rest}
  end

  defp new_word(ev, <<c::utf8, rest::binary>>, new) do
    new_word(ev, rest, [c | new])
  end

  defp do_new_word(ev, word, definition) do
    case Integer.parse(word) do
      :error -> %{ev | words: Map.put(ev.words, word, definition)}
      _ -> raise Forth.InvalidWord
    end
  end

  defp eval_word(ev, <<c::utf8, rest::binary>>, word) do
    case c do
      _ when is_separator(c) -> do_word(ev, String.upcase(String.reverse(List.to_string(word))), rest)
      _ -> eval_word(ev, rest, [c | word])
    end
  end

  defp eval_word(ev, rest="", word) do
    word = List.to_string(word)
    {ev, rest} = do_word(ev, String.upcase(String.reverse(word)), rest)
    {ev, rest}
  end

  defp do_word(ev, word, rest) do
    if Map.has_key?(ev.words, word) do
      {ev, Map.get(ev.words, word) <> rest}
    else
      {exec_word(ev, word), rest}
    end
  end

  defp exec_word(ev, "DUP") do
    %{ev | stack: do_dup(ev.stack)}
  end
  defp exec_word(ev, "DROP") do
    %{ev | stack: do_drop(ev.stack)}
  end
  defp exec_word(ev, "SWAP") do
    %{ev | stack: do_swap(ev.stack)}
  end
  defp exec_word(ev, "OVER") do
    %{ev | stack: do_over(ev.stack)}
  end
  defp exec_word(ev, _) do
    raise Forth.UnknownWord
  end

  defp do_dup([]) do
    raise Forth.StackUnderflow
  end
  defp do_dup(stack) do
    [hd(stack) | stack]
  end

  defp do_drop([]) do
    raise Forth.StackUnderflow
  end
  defp do_drop(stack) do
    tl(stack)
  end

  defp do_swap(stack) when length(stack)<=1 do
    raise Forth.StackUnderflow
  end
  defp do_swap(stack) when length(stack)==2 do
    [hd | tl] = stack
    tl ++ [hd]
  end
  defp do_swap(stack) do
    [last | tl] = stack
    [second_last | tl] = tl
    [second_last] ++ [last] ++ tl
  end

  defp do_over(stack) when length(stack)<=1 do
    raise Forth.StackUnderflow
  end
  defp do_over([hd, tl]) do
    [tl, hd, tl]
  end
  defp do_over(stack) do
    [last | tl] = stack
    second_last = hd(tl)
    [second_last] ++ [last] ++ tl
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(ev) do
    ev.stack
      |> Enum.reverse()
      |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
