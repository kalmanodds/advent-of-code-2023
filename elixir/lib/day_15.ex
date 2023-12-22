defmodule Day15 do
  @spec main(String.t()) :: integer()
  def main(file_path) do
    {_, content} = File.read(file_path)
    content
    |> String.split(",")
    |> Enum.map(&hash_step/1)
    |> Enum.reduce(0, fn (hash, acc) -> acc + hash end)
  end

  @spec hash_step(String.t()) :: integer()
  def hash_step(step) do
    step
    |> String.graphemes()
    |> Enum.map(&:binary.first/1)
    |> Enum.reduce(0, fn (ascii_number, acc) ->
      ((acc + ascii_number) * 17) |> rem(256)
    end)
  end
end
