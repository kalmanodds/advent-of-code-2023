defmodule Day14 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    content
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
    |> transpose()
    |> Enum.map(&to_string/1)
    |> Enum.map(&tilt_row/1)
    |> Enum.map(&String.graphemes/1)
    |> transpose()
    |> Enum.with_index()
    |> Enum.reduce(0, fn ({row, index}, acc) ->
      amount = row |> Enum.frequencies() |> Map.get("O", 0)
      multiplier = Enum.count(row) - index
      acc + amount * multiplier
    end)
  end

  def transpose(rows) do
    rows |> List.zip |> Enum.map(&Tuple.to_list/1)
  end

  def tilt_row(row) do
    row
    |> String.split("#")
    |> Enum.map(fn (segment) ->
      frequencies = segment |> String.graphemes() |> Enum.frequencies()
      ["O", "."]
      |> Enum.map(fn (symbol) ->
        frequency = Map.get(frequencies, symbol, 0)
        String.duplicate(symbol, frequency)
      end)
    end)
    |> Enum.join("#")
  end
end
