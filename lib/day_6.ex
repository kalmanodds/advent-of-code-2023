defmodule Day6 do
  def main(file_path) do
    {_status, content} = File.read(file_path)
    content
    |> String.split("\r\n")
    |> Enum.zip(["Time:", "Distance:"])
    |> Enum.map(fn {time, label} -> line_to_numbers(time, label) end)
    |> Enum.zip
    |> Enum.map(fn {time, distance} -> reduce_time(time, distance) end)
    |> Enum.reduce(1, fn (reduction, acc) -> acc * reduction end)
  end

  def line_to_numbers(line, label) do
    line
    |> String.split(label, trim: true)
    |> Enum.at(0)
    |> String.split(~r{\s}, trim: true)
    |> Enum.map(fn (value) ->
      {number, _} = value |> Integer.parse
      number
    end)
  end

  def reduce_time(time, distance) do
    1..time
    |> Enum.to_list
    |> Enum.reduce(0, fn (t, acc) ->
      case t * (time - t) > distance do
        true -> acc + 1
        false -> acc
      end
    end)
  end
end
