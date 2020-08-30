defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @starting_pins 10
  @last_frame 10

  @first 1
  @second 2
  @third 3

  defstruct [:score, :throw, :frames, :roll_prev, :roll_prevprev, :ended]

  @spec start() :: any
  def start do
    %__MODULE__{score: 0, throw: 1, frames: 1, roll_prev: nil, roll_prevprev: nil, ended: false}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(any, integer) :: any | String.t()
  def roll(_game, roll) when roll<0 do
    {:error, "Negative roll is invalid"}
  end
  def roll(_game, roll) when roll>@starting_pins do
    {:error, "Pin count exceeds pins on the lane"}
  end
  def roll(%Bowling{throw: throw, roll_prev: roll_prev}, roll) when throw>=@second and is_integer(roll_prev) and roll_prev+roll >@starting_pins do
    {:error, "Pin count exceeds pins on the lane"}
  end
  def roll(%Bowling{ended: true}, _roll) do
    {:error, "Cannot roll after game is over"}
  end
  def roll(game, roll) do
    game = update_score(game, roll)
    game = bump_prev(game, roll)
    game = end_game(game, roll)
    update_frame(game, roll)
  end

  defp update_score(game, roll) do
    game = update_score_prevs(game, roll)
    %{game | score: game.score + roll}
  end

  defp update_score_prevs(game=%Bowling{frames: @last_frame, throw: throw}, _roll) when throw==@third do
    game
  end
  defp update_score_prevs(game=%Bowling{frames: @last_frame, throw: throw}, roll) when throw==@second do
    prevprev_points = case game.roll_prevprev do
      :strike -> roll
      _ -> 0
    end
    %{game | score: game.score + prevprev_points}
  end
  defp update_score_prevs(game, roll) do
    prev_points = case game.roll_prev do
      :spare -> roll
      :strike -> roll
      _ -> 0
    end
    prevprev_points = case game.roll_prevprev do
      :strike -> roll
      _ -> 0
    end
    %{game | score: game.score + prev_points + prevprev_points}
  end

  defp bump_prev(game=%Bowling{roll_prev: roll_prev}, roll) when roll==@starting_pins do
    %{game | roll_prevprev: roll_prev, roll_prev: :strike}
  end
  defp bump_prev(game=%Bowling{roll_prev: roll_prev}, roll) when roll+roll_prev==@starting_pins do
    %{game | roll_prevprev: roll_prev, roll_prev: :spare}
  end
  defp bump_prev(game=%Bowling{roll_prev: roll_prev}, roll) do
    %{game | roll_prevprev: roll_prev, roll_prev: roll}
  end

  defp end_game(game=%Bowling{frames: @last_frame, throw: @second, roll_prevprev: :strike}, _roll) do
    %{game | ended: false}
  end
  defp end_game(game=%Bowling{frames: @last_frame, throw: @second, roll_prev: :spare}, _roll) do
    %{game | ended: false}
  end
  defp end_game(game=%Bowling{frames: @last_frame, throw: throw}, _roll) when throw>=@second do
    %{game | ended: true}
  end
  defp end_game(game, _roll) do
    %{game | ended: false}
  end

  defp update_frame(game=%Bowling{frames: @last_frame, throw: throw}, _roll) do
    %{game | throw: throw + 1}
  end
  defp update_frame(game=%Bowling{frames: frames, throw: @second}, _roll) do
    %{game | throw: 1, frames: frames+1}
  end
  defp update_frame(game=%Bowling{frames: frames}, @starting_pins) do
    %{game | throw: 1, frames: frames+1}
  end
  defp update_frame(game, _roll) do
    %{game | throw: game.throw + 1}
  end

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(any) :: integer | String.t()
  def score(%Bowling{ended: false}) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  def score(game) do
    game.score
  end
end
