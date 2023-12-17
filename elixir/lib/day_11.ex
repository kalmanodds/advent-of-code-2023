defmodule Day11 do
  def main(file_path) do
    {_status, content} = File.read(file_path)
    universe = content
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()

    galaxy_gaps = universe
    |> find_galaxies()
    |> find_galaxy_gaps(universe)

    universe
    |> expand_universe(galaxy_gaps)
    |> Enum.with_index()
    |> find_galaxies()
    |> get_galaxy_pairs()
    |> Enum.reduce(0, fn ({{x1, y1}, {x2, y2}}, acc) ->
      acc + abs(x1 - x2) + abs(y1 - y2)
    end)
  end

  def find_galaxies(lines, x_offset \\ 0)
  def find_galaxies([], _x_offset) do [] end
  def find_galaxies([{line, y_index} | rest], x_offset) do
    case line |> Enum.find_index(&(&1 === "#")) do
      nil -> find_galaxies(rest)
      x_index ->
        {_, remaining_line} = line |> Enum.split(x_index + 1)
        remaining_line = {remaining_line, y_index}
        new_offset = x_offset + x_index + 1
        remaining_galaxies = find_galaxies([remaining_line | rest], new_offset)
        [{x_index + x_offset, y_index} | remaining_galaxies]
    end
  end

  def find_galaxy_gaps(galaxies, universe) do
    {x_galaxies, y_galaxies} = galaxies |> Enum.unzip()
    {x, _} = universe |> Enum.at(0)
    x_length = x |> Enum.count()
    y_length = universe |> Enum.count()
    x_indices = (0..(x_length - 1)) |> Enum.to_list()
    y_indices = (0..(y_length - 1)) |> Enum.to_list()
    x_gaps = x_indices |> Enum.filter(&!Enum.member?(x_galaxies, &1))
    y_gaps = y_indices |> Enum.filter(&!Enum.member?(y_galaxies, &1))
    {x_gaps, y_gaps}
  end

  def expand_universe([], _galaxy_gaps) do [] end
  def expand_universe(universe, galaxy_gaps) do
    [{head, index} | tail] = universe
    {x_gaps, y_gaps} = galaxy_gaps
    remaining_universe = expand_universe(tail, galaxy_gaps)
    case y_gaps |> Enum.member?(index) do
      true ->
        x_length = Enum.count(head) + Enum.count(x_gaps)
        newRow = List.duplicate(".", x_length)
        [newRow | [newRow | remaining_universe]]
      false ->
        indexed_row = head |> Enum.with_index()
        newRow = expand_row(indexed_row, x_gaps)
        [newRow | remaining_universe]
    end
  end

  def expand_row([], _x_gaps) do [] end
  def expand_row(row, x_gaps) do
    [{head, index} | tail] = row
    remaining_row = expand_row(tail, x_gaps)
    case x_gaps |> Enum.member?(index) do
      true -> [head | [head | remaining_row]]
      false -> [head | remaining_row]
    end
  end

  def get_galaxy_pairs([]) do [] end
  def get_galaxy_pairs(galaxies) do
    [head | tail] = galaxies
    pairs = tail |> Enum.map(&({head, &1}))
    remaining_pairs = get_galaxy_pairs(tail)
    pairs ++ remaining_pairs
  end
end
