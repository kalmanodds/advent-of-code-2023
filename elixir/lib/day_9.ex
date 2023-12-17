defmodule Day9 do
  def main(file_path) do
    {_status, content} = File.read(file_path)
    content
    |> String.split("\r\n")
    |> Enum.map(fn (line) -> line
      |> String.split(~r{\s}, trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn (line) -> extrapolate_line([line]) end)
    |> Enum.map(&extrapolate_diagonal/1)
    |> Enum.sum()
  end

  def extrapolate_line(levels) do
    [latest_level | _rest] = levels
    case latest_level |> Enum.all?(&(&1 === 0)) do
      true -> levels
      false ->
        [head | latest_level] = latest_level
        new_level = extrapolate_level(latest_level, head)
        extrapolate_line([new_level | levels])
    end
  end

  def extrapolate_level([], _prev_value) do [] end
  def extrapolate_level(line, prev_value) do
    [value | rest] = line
    difference = value - prev_value
    [difference | extrapolate_level(rest, value)]
  end

  def extrapolate_diagonal(levels) do
    levels |> Enum.reduce(0, fn (level, acc) ->
      acc + Enum.at(level, Enum.count(level) - 1)
    end)
  end
end
