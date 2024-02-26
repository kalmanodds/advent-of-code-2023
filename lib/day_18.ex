defmodule Day18 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    instructions = content
    |> String.split("\r\n")
    |> Enum.map(fn (instruction) ->
      [direction, count, _] = String.split(instruction, " ")
      {direction, String.to_integer(count)}
    end)

    {vertices, sum} = instructions |> get_vertices_and_perimeter()
    area = vertices |> compute_area()

    area + sum
  end

  def get_vertices_and_perimeter(instructions) do
    vertex = {0, 0}
    {_, vertices, sum} = instructions
    |> Enum.reduce({vertex, [vertex], 2},
      fn (instruction, {vertex, vertices, sum}) ->
        {direction, count} = instruction
        new_vertex = update_vertex(vertex, direction, count)
        {new_vertex, [new_vertex | vertices], sum + count}
      end)
    {vertices, sum |> div(2)}
  end

  def update_vertex({x, y}, direction, increment \\ 1) do
    case direction do
      "R" -> {x + increment, y}
      "L" -> {x - increment, y}
      "U" -> {x, y - increment}
      "D" -> {x, y + increment}
    end
  end

  def compute_area([{x1, y1} | rest]) do
    {area, _} = rest
    |> Enum.reduce({0, {x1, y1}}, fn {x2, y2}, {acc, {x1, y1}} ->
      product1 = x1 * y2
      product2 = x2 * y1
      new_acc = acc + product1 - product2
      {new_acc, {x2, y2}}
    end)
    area |> abs() |> div(2)
  end
end
