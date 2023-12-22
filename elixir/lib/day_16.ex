defmodule Day16 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    grid = content
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
    |> traverse_grid()
    |> Map.keys()
    |> Enum.count()
    grid
  end

  def traverse_grid(grid, direction \\ :right, position \\ {0, 0}, state \\ %{}) do
    if out_of_bounds?(grid, position) do
      state
    else
      {x, y} = position
      current_symbol = grid |> Enum.at(y) |> Enum.at(x)
      combos = [
        {direction, [{direction, "."}]},
        {:up, [{:up, "|"}, {:left, "\\"}, {:right, "/"}]},
        {:down, [{:down, "|"}, {:left, "/"}, {:right, "\\"}]},
        {:left, [{:left, "-"}, {:up, "\\"}, {:down, "/"}]},
        {:right, [{:right, "-"}, {:up, "/"}, {:down, "\\"}]},
        {{:up, :down}, [{:left, "|"}, {:right, "|"}]},
        {{:left, :right}, [{:up, "-"}, {:down, "-"}]}
      ]
      new_direction = combos |> Enum.find(fn {_, combos} ->
        Enum.any?(combos, &(&1 === {direction, current_symbol}))
      end)
      case new_direction do
        {{direction_1, direction_2}, _} ->
          new_state = traverse_direction(grid, direction_1, position, state)
          traverse_direction(grid, direction_2, position, new_state)
        {new_direction, _} ->
          traverse_direction(grid, new_direction, position, state)
      end
    end
  end

  def traverse_direction(grid, direction, position, state) do
    if Map.fetch(state, position) === {:ok, direction} do
      state
    else
      new_state = state |> Map.put(position, direction)
      new_position = update_position(position, direction)
      traverse_grid(grid, direction, new_position, new_state)
    end
  end

  def out_of_bounds?(grid, {x, y}) do
    x_length = grid |> Enum.at(0) |> Enum.count()
    y_length = grid |> Enum.count()
    [x, y]
    |> Enum.zip([x_length, y_length])
    |> Enum.any?(fn ({position, length}) ->
      position < 0 || position >= length
    end)
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
