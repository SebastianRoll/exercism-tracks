defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(tree, data) do
    _insert(tree, tree, data)
  end
  def _insert(tree, node=%{data: node_data, left: left}, data) when data <= node_data do
    if is_nil(left) do
      %{node | left: new(data)}
      tree
    else
      _insert(tree, node.left, data)
    end
  end
  def _insert(tree, node=%{data: node_data, right: right}, data) when data > node_data do
    if is_nil(right) do
      %{node | right: new(data)}
      tree
    else
      _insert(tree, node.right, data)
    end
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree) do
    # Your implementation here
  end
end

root =  BinarySearchTree.new(4)
root = BinarySearchTree.insert(root, 2)