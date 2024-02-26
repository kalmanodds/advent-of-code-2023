defmodule Day22 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    content |> input_to_list() |> get_dimensions()


  end

  def input_to_list(content) do
    content
    |> String.split("\r\n")
    |> Enum.map(fn (line) ->
      line
      |> String.split("~")
      |> Enum.map(fn (coords) ->
        coords
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
      |> List.to_tuple()
    end)
  end

  def get_dimensions(input_list) do
    {x_dim, y_dim} = input_list
    |> Enum.reduce({0, 0}, fn (line, dimensions) ->
      {{x1, y1, _z1}, {x2, y2, _z2}} = line
      {x_dim, y_dim} = dimensions

      new_x_dim = Enum.max([x1, x2, x_dim])
      new_y_dim = Enum.max([y1, y2, y_dim])
      {new_x_dim, new_y_dim}
    end)

    {x_dim + 1, y_dim + 1}
  end

  def create_maps(input_list, dimensions) do
    {x_dim, y_dim} = dimensions
    input_list
    |> Enum.with_index()
    |> Enum.reduce({%{}, %{}}, fn ({line, label}, maps) ->
      {{x1, y1, z1}, {x2, y2, z2}} = line
      {x_map, y_map} = maps
      case get_orientation(line) do
        :x ->
          x_map = x_map |> insert_horizontal({x1, x2, z1}, label, y_dim)
          y_map = y_map |> insert_forward({y1, z1}, label, x_dim)
          {x_map, y_map}
        :y ->
          x_map = x_map |> insert_forward({x1, z1}, label, y_dim)
          y_map = y_map |> insert_horizontal({y1, y2, z1}, label, x_dim)
          {x_map, y_map}
        :z ->
          x_map = insert_vertical(line, x_map)
          y_map = insert_vertical(line, y_map)
          {x_map, y_map}
      end

    end)
  end

  def get_orientation(line) do
    {{x1, y1, z1}, {x2, y2, z2}} = line
    case {abs(x1 - x2), abs(y1 - y2), abs(z1 - z2)} do
      {_, 0, 0} -> :x
      {0, _, 0} -> :y
      {0, 0, _} -> :z
    end
  end

  def insert_forward(map, indices, label, dimension) do
    {x, y} = indices
    {list1, [head | list2]} = map
    |> Map.get(y, List.duplicate([], dimension))
    |> Enum.split(x)

    new_row = list1 ++ [[label | head]] ++ list2
    map |> Map.put(y, new_row)
  end

  def insert_horizontal(map, indices, label, dimension) do
    {x1, x2, y} = indices
    {list1, list2} = map
    |> Map.get(y, List.duplicate([], dimension))
    |> Enum.split(x1)
    {list2, list3} = Enum.split(list2, x2)

    new_row = list1 ++ Enum.map(list2, &([label | &1])) ++ list3
    map |> Map.put(y, new_row)
  end

  def insert_vertical(line, map) do

  end
end
