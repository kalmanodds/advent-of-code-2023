defmodule Day4 do
  @spec main(String.t()) :: integer()
  def main(file_path) do
    {_status, content} = File.read(file_path)
    String.split(content, "\r\n")
    |> Enum.reduce(0, fn (line, acc) -> reduce_line(line, acc) end)
    |> trunc
  end

  @spec reduce_line(String.t(), integer()) :: integer()
  def reduce_line(line, acc) do
    body = line |> String.split(": ") |> Enum.at(1)
    numbers = body |> String.split(" | ")
    winning_count = numbers
    |> Enum.at(0)
    |> String.split(~r{\s}, trim: true)
    |> Enum.reduce(0, fn (number, acc) ->
      case numbers
      |> Enum.at(1)
      |> String.split(~r{\s}, trim: true)
      |> Enum.member?(number) do
        true -> acc + 1
        false -> acc
      end
    end)
    case winning_count > 0 do
      true -> acc + :math.pow(2, winning_count - 1)
      false -> acc
    end
  end
end
