defmodule Day21 do
  def main(file_path, steps \\ 64) do
    {_, content} = File.read(file_path)
    lines = content |> String.split("\r\n")

    dimensions = get_dimensions(lines)
    maps = init_maps(lines)

    output_map = iterate_map(maps, dimensions, steps)
    output_map |> Map.keys() |> Enum.count()
  end

  def get_dimensions(lines) do
    x_dim = Enum.count(lines)
    y_dim = lines |> List.first() |> String.length()
    {x_dim, y_dim}
  end

  def init_maps(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce({%{}, %{}}, fn ({line, y}, maps) ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(maps, fn ({symbol, x}, maps) ->
        {rock_map, input_map} = maps
        case symbol do
          "#" ->
            new_rock_map = Map.put(rock_map, {x, y}, "#")
            {new_rock_map, input_map}
          "S" ->
            new_input_map = Map.put(input_map, {x, y}, "O")
            {rock_map, new_input_map}
          _ -> maps
        end
      end)
    end)
  end

  def iterate_map({_rock_map, input_map}, _dimensions, 0) do input_map end
  def iterate_map({rock_map, input_map}, dimensions, steps) do
    output_map = input_map
    |> Map.keys()
    |> Enum.reduce(%{}, fn (key, output_map) ->
      get_neighboring_keys(key)
      |> Enum.filter(&!is_out_of_bounds?(&1, dimensions))
      |> Enum.filter(&!is_rock?(&1, rock_map))
      |> Enum.reduce(output_map, fn (key, output_map) ->
        output_map |> Map.put(key, "O")
      end)
    end)

    iterate_map({rock_map, output_map}, dimensions, steps - 1)
  end

  def get_neighboring_keys({x, y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
  end

  def is_out_of_bounds?({x, y}, {x_dim, y_dim}) do
    x < 0 || x > x_dim || y < 0 || y > y_dim
  end

  def is_rock?(key, rock_map) do
    rock_map |> Map.keys() |> Enum.member?(key)
  end
end
