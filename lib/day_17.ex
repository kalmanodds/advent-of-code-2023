defmodule Day17 do
  @moduledoc """
  Fortunately, the Elves here have a map (your puzzle input) that uses traffic patterns,
  ambient temperature, and hundreds of other parameters to calculate exactly
  how much heat loss can be expected for a crucible entering any particular city block.

  For example:

  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533

  Each city block is marked by a single digit that represents the amount of heat loss if the crucible enters that block.
  The starting point, the lava pool, is the top-left city block; the destination, the machine parts factory, is the bottom-right city block.
  (Because you already start in the top-left block, you don't incur that block's heat loss unless you leave that block and then return to it.)

  Because it is difficult to keep the top-heavy crucible going in a straight line for very long,
  it can move at most three blocks in a single direction before it must turn 90 degrees left or right.
  The crucible also can't reverse direction; after entering each city block, it may only turn left, continue straight, or turn right.

  One way to minimize heat loss is this path:

  2>>34^>>>1323
  32v>>>35v5623
  32552456v>>54
  3446585845v52
  4546657867v>6
  14385987984v4
  44578769877v6
  36378779796v>
  465496798688v
  456467998645v
  12246868655<v
  25465488877v5
  43226746555v>

  This path never moves more than three consecutive blocks in the same direction and incurs a heat loss of only 102.

  Directing the crucible from the lava pool to the machine parts factory,
  but not moving more than three consecutive blocks in the same direction, what is the least heat loss it can incur?
  """

  def main(file_path) do
    {_, content} = File.read(file_path)
    grid = content
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)

    {count, _} = traverse_grid(grid)
    count
  end

  def traverse_grid(grid, position \\ {0, 0}, state \\ {:right, 0, 0, %{}}) do
    if can_traverse?(grid, position, state) do
      proceed_traversal(grid, position, state)
    else
      state
    end
  end

  def can_traverse?(grid, position, state) do
    {direction, direction_counter, current_count, grid_state} = state
    {x, y} = position
    tile = grid |> Enum.at(y) |> Enum.at(x)
    state_index = {position, direction, direction_counter}
    case Map.fetch(grid_state, state_index) do
      {:ok, tile_best} -> tile_best > (current_count + tile)
      :error -> true
    end

  end

      # {direction, direction_counter, total_counter, grid_state} = state
      # %{ {{x, y} direction, direction_counter} => total_counter } = grid_state

  def proceed_traversal(grid, position, state) do
    {x, y} = position
    {direction, direction_counter, _current_count, _grid_state} = state
    x_length = grid |> Enum.at(0) |> Enum.count()
    y_length = grid |> Enum.count()
    tile = grid |> Enum.at(y) |> Enum.at(x) |> String.to_integer()
    IO.puts(tile)
    is_finished? = x === (x_length - 1) && y === (y_length - 1)
    if is_finished? do

    end
    state_index = {position, direction, direction_counter}
    left_allowed = x > 0 && direction !== :right && {direction, direction_counter} !== {:left, 3}
    right_allowed = x < (x_length - 1) && direction !== :left && {direction, direction_counter} !== {:right, 3}
    up_allowed = y > 0 && direction !== :down && {direction, direction_counter} !== {:up, 3}
    down_allowed = y < (y_length - 1) && direction !== :up && {direction, direction_counter} !== {:down, 3}
    [left_allowed, right_allowed, up_allowed, down_allowed]
    |> Enum.zip([:left, :right, :up, :down])
    |> Enum.reduce(state, fn ({_, new_direction}, state) ->
      {direction, direction_counter, current_count, grid_state} = state
      new_position = update_position({x, y}, new_direction)
      new_direction_counter =
        update_direction_counter(direction, direction_counter, new_direction)
      new_total = current_count + tile
      new_grid_state = Map.put(grid_state, state_index, new_total)
      new_state = {new_direction, new_direction_counter, new_total, new_grid_state}
      traverse_grid(grid, new_position, new_state)
    end)

  end

  def update_direction_counter(old_direction, direction_counter, new_direction) do
    if old_direction === new_direction do direction_counter + 1 else 1 end
  end

  def update_position({x, y}, direction) do
    case direction do
      :up -> {x, y - 1}
      :down -> {x, y + 1}
      :left -> {x - 1, y}
      :right -> {x + 1, y}
    end
  end

end
