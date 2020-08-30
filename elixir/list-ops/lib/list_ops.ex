defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: do_count(l, 0)
  defp do_count([_hd|tl], counter), do: do_count(tl, counter+1)
  defp do_count([], counter), do: counter

  @spec reverse(list) :: list
  def reverse(l), do: do_reverse(l, [])
  defp do_reverse([hd|tl], rev), do: do_reverse(tl, [hd | rev])
  defp do_reverse([], rev), do: rev

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: do_map(l, f, [])
  defp do_map([hd|tl], f, mapped), do: do_map(tl, f, [f.(hd) | mapped])
  defp do_map([], _f, mapped), do: reverse(mapped)

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: do_filter(l, f, [])
  defp do_filter([hd|tl], f, filtered) do
    filtered = case f.(hd) do
      true -> [hd | filtered]
      false -> filtered
    end
    do_filter(tl, f, filtered)
  end
  defp do_filter([], _f, filtered), do: reverse(filtered)

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce(l, acc, f), do: do_reduce(l, acc, f)
  defp do_reduce([hd|tl], acc, f), do: do_reduce(tl, f.(hd, acc), f)
  defp do_reduce([], acc, _f), do: acc

  @spec append(list, list) :: list
  def append(a, b), do: do_append(reverse(a), b)
  defp do_append([hd|tl], b), do: do_append(tl, [hd | b])
  defp do_append([], b), do: b

  @spec concat([[any]]) :: [any]
  def concat(ll), do: do_concat(ll, [])
  defp do_concat([hd|tl], concated) when is_list(hd) do
    do_concat(tl, do_append(hd, concated))
  end
  defp do_concat([], concated), do: reverse(concated)
end
