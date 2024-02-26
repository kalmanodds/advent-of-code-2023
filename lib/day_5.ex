defmodule Day5 do
  def main(file_path) do
    {_status, content} = File.read(file_path)
    [inputs, rest] = content
    |> String.split("seeds: ", trim: true)
    |> Enum.at(0)
    |> String.split("\r\nseed-to-soil map:\r\n")
    [map1, rest] = rest |> String.split("\r\nsoil-to-fertilizer map:\r\n")
    [map2, rest] = rest |> String.split("\r\nfertilizer-to-water map:\r\n")
    [map3, rest] = rest |> String.split("\r\nwater-to-light map:\r\n")
    [map4, rest] = rest |> String.split("\r\nlight-to-temperature map:\r\n")
    [map5, rest] = rest |> String.split("\r\ntemperature-to-humidity map:\r\n")
    [map6, map7] = rest |> String.split("\r\nhumidity-to-location map:\r\n")

    inputs
    |> String.split(~r{\s}, trim: true)
    |> Enum.map(fn (input) ->
      {input, _} = Integer.parse(input)
      input
    end)
    |> traverse_maps([map1, map2, map3, map4, map5, map6, map7])
    |> Enum.min
  end

  def traverse_maps(inputs, []) do inputs end
  def traverse_maps(inputs, maps) when maps !== [] do
    [map | rest] = maps
    ranges = map
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn (line) -> create_ranges(line) end)

    inputs
    |> Enum.map(fn (input) -> input |> traverse_ranges(ranges) end)
    |> traverse_maps(rest)
  end

  def create_ranges(line) do
    [destination, source, offset] = line
    |> String.split(~r{\s}, trim: true)
    |> Enum.map(fn (string) ->
      {number, _} = Integer.parse(string)
      number
    end)
    {source, destination, offset}
  end

  def traverse_ranges(input, []) do input end
  def traverse_ranges(input, [range | rest]) do
    {source, destination, offset} = range
    case source <= input && input < source + offset do
      true ->
        index = input - source
        destination + index
      false -> input |> traverse_ranges(rest)
    end
  end
end
