defmodule Day8 do
  @spec main(String.t()) :: integer()
  def main(file_path) do
    {_status, content} = File.read(file_path)
    [directions, network] = content |> String.split("\r\n\r\n")
    directions = directions |> String.graphemes()
    network
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, [" = (", ", ", ")"], trim: true))
    |> traverse_network("AAA", directions, directions)
  end

  @spec traverse_network([String.t()], String.t(), [String.grapheme()], [String.grapheme()], integer()) :: integer()
  def traverse_network(network, root, directions, initial_directions, acc \\ 0)
  def traverse_network(network, root, [], initial_directions, acc) do
    case root do
      "ZZZ" -> acc
      _ -> traverse_network(network, root, initial_directions, initial_directions, acc)
    end
  end
  def traverse_network(network, root, directions, initial_directions, acc) do
    [direction | rest] = directions
    [_node, left, right] = network
    |> Enum.find(fn [node, _left, _right] -> node === root end)
    case direction do
      "R" -> traverse_network(network, right, rest, initial_directions, acc + 1)
      "L" -> traverse_network(network, left, rest, initial_directions, acc + 1)
    end
  end
end
