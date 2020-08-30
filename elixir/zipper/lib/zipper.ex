defmodule Zipper do
  @type t :: %Zipper{focus: BinTree.t(), before: list(BinTree.t()), sons: list(atom)}
  defstruct [:focus, :before, :sons]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %__MODULE__{focus: bin_tree, before: [], sons: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{focus: focus, before: []}) do
    focus
  end
  def to_tree(zipper) do
    to_tree(up(zipper))
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(zipper) do
    zipper.focus.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(zipper) do
    case zipper.focus.left do
      nil -> nil
      _ -> %__MODULE__{focus: zipper.focus.left, before: [zipper.focus | zipper.before], sons: [:left | zipper.sons]}
    end

  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(zipper) do
    case zipper.focus.right do
      nil -> nil
      _ ->  %__MODULE__{focus: zipper.focus.right, before: [zipper.focus | zipper.before], sons: [:right | zipper.sons]}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{before: []}) do
    nil
  end
  def up(zipper) do
    [hd | tl] = zipper.before
    [son | sons] = zipper.sons
    hd = case son do
      :left -> %{hd | left: zipper.focus}
      :right -> %{hd | right: zipper.focus}
      _ -> hd
    end
    %__MODULE__{focus: hd, before: tl, sons: sons}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    %{zipper | focus: %{zipper.focus | value: value}}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    %{zipper | focus: %{zipper.focus | left: left}}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    %{zipper | focus: %{zipper.focus | right: right}}
  end
end
