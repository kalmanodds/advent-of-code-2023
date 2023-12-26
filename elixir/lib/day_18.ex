defmodule Day18 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    instructions = content
    |> String.split("\r\n")
    |> Enum.map(fn (instruction) ->
      [direction, count, _] = String.split(instruction, " ")
      {direction, String.to_integer(count)}
    end)

    dimensions = instructions
    |> find_dimensions()

    edge_count = instructions
    |> create_coords_list()
    |> count_edges(dimensions)

    [x_length, y_length] = dimensions
    (x_length + 1) * (y_length + 1) - edge_count
  end

  def find_dimensions(instructions) do
    {list, _} = instructions
    |> Enum.map_reduce({0, 0}, fn (instruction, {x, y}) ->
      {direction, count} = instruction
      new_acc = increment_coords({x, y}, direction, count)
      {new_acc, new_acc}
    end)

    {x_list, y_list} = list |> Enum.unzip()
    [x_list, y_list] |> Enum.map(&Enum.max/1)
  end

  def increment_coords({x, y}, direction, increment \\ 1) do
    case direction do
      "R" -> {x + increment, y}
      "L" -> {x - increment, y}
      "U" -> {x, y - increment}
      "D" -> {x, y + increment}
    end
  end

  def create_coords_list(instructions) do
    coords = {0, 0}
    {_, coords_list} = instructions
    |> Enum.reduce({coords, [coords]}, fn (instruction, {coords, coords_list}) ->
      {direction, count} = instruction
      new_coords_list = (1..count)
      |> Enum.to_list()
      |> Enum.map(&increment_coords(coords, direction, &1))
      {List.last(new_coords_list), coords_list ++ new_coords_list}
    end)
    coords_list
  end

  def count_edges([coords | coords_list], dimensions) do
    {_, _, edge_count} = coords_list
    |> Enum.reduce({coords, coords_list, 0}, fn (coords, acc) ->
      {last_coords, coords_list, edge_count} = acc
      direction = determine_direction(last_coords, coords)
      new_coords = increment_coords(coords, direction)
      new_acc = {coords, coords_list, edge_count}
      if within_range?(new_coords, dimensions) do
        count_edge(new_coords, new_acc, dimensions)
      else
        new_acc
      end
    end)
    edge_count
  end

  def within_range?({x, y}, dimensions) do
    [x_length, y_length] = dimensions
    x >= 0 && x <= x_length && y >= 0 && y <= y_length
  end

  def determine_direction({x1, y1}, {x2, y2}) do
    cond do
      x1 < x2 -> "U" # right
      x1 > x2 -> "D" # left
      y1 < y2 -> "R" # down
      y1 > y2 -> "L" # up
    end
  end

  def count_edge(coords, acc, dimensions) do
    {last_coords, coords_list, edge_count} = acc
    if Enum.member?(coords_list, coords) do
      acc
    else
      new_coords_list = [coords | coords_list]
      new_count = edge_count + 1
      new_acc = {last_coords, new_coords_list, new_count}
      ["R", "L", "U", "D"]
      |> Enum.map(&increment_coords(coords, &1))
      |> Enum.filter(&within_range?(&1, dimensions))
      |> Enum.reduce(new_acc, fn (coords, acc) ->
        count_edge(coords, acc, dimensions)
      end)
    end
  end
end
