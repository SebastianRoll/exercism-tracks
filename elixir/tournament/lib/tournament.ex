defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    score = %{
      :MP => %{},
      :W => %{},
      :D => %{},
      :L => %{},
      :P => %{},
    }
    score = Enum.reduce(input, score, fn match_input, acc -> process_match(match_input, acc) end)
    format(score)
  end

  def format(score) do
    %{:P => points} = score
    teams = Enum.to_list(points)
      |> Enum.sort(fn({key1, value1}, {key2, value2}) ->
      if value1 == value2 do
        key1 < key2
      else
        value1 > value2
      end end)
      |> Enum.map(&(elem(&1, 0)))
    format = Enum.map(teams, fn team -> format_team(team, score) end)
      |> Enum.join("\n")
    "Team                           | MP |  W |  D |  L |  P\n" <> format
  end

  def format_team(team, score) do
    forh = Enum.map([:MP, :W, :D, :L, :P], &(get(team, score, &1)))
      |> Enum.map(&(String.pad_leading(Integer.to_string(&1), 3)))
      |> Enum.join(" |")
    String.pad_trailing(team, 30) <> " |" <> forh #{get(team, score, :W)}"
  end

  def process_match(match_input, score) do
    case String.split(match_input, ";") do
      [team1, team2, result] -> pro(team1, team2, result, score)
      _ -> score
    end
  end

  def pro(team1, team2, result, score) do
    score = case result do
      "win" ->
        score = update(team1, score, :W)
        score = update(team1, score, :P, 3)
        score = update(team2, score, :L)
        update(team2, score, :P, 0)
      "loss" ->
        score = update(team1, score, :L)
        score = update(team1, score, :P, 0)
        score = update(team2, score, :W)
        update(team2, score, :P, 3)
      "draw" ->
        score = update(team1, score, :D)
        score = update(team2, score, :D)
        score = update(team1, score, :P)
        update(team2, score, :P)
      _ -> score
    end
    score = update(team1, score, :MP)
    score = update(team2, score, :MP)
  end

  def get(team, score, key) do
    %{^key => column} = score
    Map.get(column, team, 0)
  end

  def update(team, score, key, incr \\ 1) do
    %{^key => column} = score
    new = Map.get(column, team, 0) + incr
    column = Map.put(column, team, new)
    Map.put(score, key, column)
  end
end
