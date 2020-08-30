defmodule RobotSimulator do
  defstruct [:position, :direction]

  defguard is_position(x, y) when is_integer(x) and is_integer(y)

  @directions ~w(north south east west)a
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0})

  def create(direction, _position) when direction not in @directions do
    {:error, "invalid direction"}
  end

  def create(direction, position={x, y}) when is_position(x, y) do
      %__MODULE__{direction: direction, position: position}
  end

  def create(_direction, _position) do
      {:error, "invalid position"}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, "") do
    robot
  end

  def simulate(robot, <<instruction :: binary - size(1), rest :: binary>>) do
    case instruction do
      direction when direction in ["L", "R"] ->
        robot = rotate(robot, direction)
        simulate(robot, rest)
      "A" ->
        robot = advance(robot)
        simulate(robot, rest)
      _ -> {:error, "invalid instruction"}
    end
  end

  @doc """
  Rotate the robot in a clockwise direction.
  """
  def rotate(robot, "R") do
    direction = case robot.direction do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
    %__MODULE__{direction: direction, position: robot.position}
  end

  @doc """
  Rotate the robot in a counter-clockwise direction.
  """
  @spec rotate(robot :: any, String.t()) :: robot :: any
  def rotate(robot, "L") do
    direction = case robot.direction do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
    %__MODULE__{direction: direction, position: robot.position}
  end

  @doc """
  Move the robot forward.
  """
  @spec advance(robot :: any) :: robot :: any
  def advance(robot = %__MODULE__{position: {x, y}}) do
    new_position = case robot.direction do
      :north -> {x, y + 1}
      :east -> {x + 1, y}
      :south -> {x, y - 1}
      :west -> {x - 1, y}
    end
    %{robot | position: new_position}
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(%{direction: dir}), do: dir

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(%{position: pos}), do: pos
end
