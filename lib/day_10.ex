defmodule Day10 do
  @north_pipes [{"|", :north}, {"L", :west},  {"J", :east}]
  @south_pipes [{"|", :south}, {"7", :east},  {"F", :west}]
  @west_pipes  [{"-", :west},  {"J", :south}, {"7", :north,}]
  @east_pipes  [{"-", :east},  {"L", :south}, {"F", :north,}]

  @spec main(String.t()) :: integer()
  def main(file_path) do
    {_status, content} = File.read(file_path)
    tiles = content
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
    tiles
    |> get_starting_tile()
    |> start_traversal(tiles)
  end

  defp get_starting_tile(tiles, index \\ 0)
  defp get_starting_tile([tile | rest], i) do
    case tile |> Enum.find_index(&(&1 === "S")) do
      nil -> get_starting_tile(rest, i + 1)
      j -> {j, i}
    end
  end

  defp start_traversal({x, y}, tiles) do
    {_pipe, prev, x, y} = [
      {@north_pipes, :north, x, y + 1},
      {@south_pipes, :south, x, y - 1},
      {@east_pipes,  :east,  x - 1, y},
      {@west_pipes,  :west,  x + 1, y}]
    |> Enum.find(fn {pipes, _prev, x, y} ->
      current_tile = tiles |> Enum.at(y) |> Enum.at(x)
      pipes |> Enum.any?(fn {tile, _} -> tile === current_tile end)
    end)
    traverse_pipes(tiles, {x, y}, {"S", prev}, 1)
  end

  defp traverse_pipes(tiles, {x1, y1}, prev_pipe, acc) do
    current_tile = tiles |> Enum.at(y1) |> Enum.at(x1)
    if current_tile === "S" do
      div(acc, 2) + rem(acc, 2)
    else
      current_pipes = case prev_pipe do
        {_, :north} -> @north_pipes
        {_, :south} -> @south_pipes
        {_, :west} ->  @west_pipes
        {_, :east} ->  @east_pipes
      end
      current_pipe = current_pipes
      |> Enum.find(fn {tile, _} -> tile === current_tile end)
      {x2, y2} = case current_pipe do
        {_, :north} -> {x1, y1 + 1}
        {_, :south} -> {x1, y1 - 1}
        {_, :west} ->  {x1 + 1, y1}
        {_, :east} ->  {x1 - 1, y1}
      end
      traverse_pipes(tiles, {x2, y2}, current_pipe, acc + 1)
    end
  end
end
