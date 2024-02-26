defmodule Day13 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    content
    |> String.split("\r\n\r\n")
    |> Enum.map(&String.split(&1, "\r\n"))
    |> Enum.map(&get_reflection_offset/1)
    |> Enum.reduce(0, fn (offset, acc) -> acc + offset end)
  end

  def get_reflection_offset(pattern) do
    case get_horizontal_reflection_offset(pattern) do
      nil -> get_vertical_reflection_offset(pattern)
      offset -> offset * 100
    end
  end

  def get_horizontal_reflection_offset(pattern) do
    pattern_length = Enum.count(pattern)
    (1..(pattern_length - 1))
    |> Enum.to_list()
    |> Enum.find(fn (index) -> pattern |> contains_reflection?(index) end)
  end

  def get_vertical_reflection_offset(pattern) do
    line_length = pattern |> Enum.at(0) |> String.length()
    (1..(line_length - 1))
    |> Enum.to_list()
    |> Enum.find(fn (index) ->
      pattern |> Enum.all?(fn (line) ->
        line |> String.graphemes() |> contains_reflection?(index)
      end)
    end)
  end

  def contains_reflection?(list, index) do
    {top, bottom} = Enum.split(list, index)
    min_length = min(Enum.count(top), Enum.count(bottom))
    {transformed_top, _} = top |> Enum.reverse() |> Enum.split(min_length)
    {transformed_bottom, _} = bottom |> Enum.split(min_length)
    transformed_top === transformed_bottom
  end
end
