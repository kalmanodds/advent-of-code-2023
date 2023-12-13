defmodule Day3 do
  @moduledoc """
  Documentation for `ElixirAoc`.
  """
  def main(file_path) do
    {_status, content} = File.read(file_path)
    lines = String.split(content, "\r\n")

    number_lines = lines |> Enum.map(fn (line) -> parse_numbers(line) end)
    symbol_lines = lines |> Enum.map(fn (line) -> parse_symbols(line) end)

    # TODO: reduce
    number_lines
    |> Enum.with_index
    |> Enum.reduce(0, fn ({numbers, i}, acc) ->
      numbers |> Enum.reduce(acc, fn (number, acc) ->
        {_, _, value} = number
        case has_neighboring_symbol(number, symbol_lines, i) do
          true -> acc + value
          false -> acc
        end
      end)
    end)
  end

  def parse_numbers(line, index \\ 0)
  def parse_numbers("", _index) do [] end
  def parse_numbers(line, index) when line !== "" do
    {first, remaining_line} = String.split_at(line, 1)
    case Integer.parse(first) do
      {_, _} ->
        {number, remaining_line} = Integer.parse(line)
        number_length = String.length(line) - String.length(remaining_line)
        index2 = index + number_length - 1
        [{index, index2, number} | parse_numbers(remaining_line, index + number_length)]
      :error ->
        parse_numbers(remaining_line, index + 1)
    end
  end

  def parse_symbols(line, index \\ 0)
  def parse_symbols("", _index) do [] end
  def parse_symbols(line, index) when line !== "" do
    {first, remaining_line} = String.split_at(line, 1)
    case Integer.parse(first) do
      {_, _} ->
        {_, remaining_line} = Integer.parse(line)
        number_length = String.length(line) - String.length(remaining_line)
        parse_symbols(remaining_line, index + number_length)
      :error ->
        case first do
          "." -> parse_symbols(remaining_line, index + 1)
          _ -> [{index, first} | parse_symbols(remaining_line, index + 1)]
        end
    end
  end

  def has_neighboring_symbol(number, symbol_lines, index) do
    {x1, x2, _} = number
    neighboring_range = Enum.to_list(x1 - 1..x2 + 1)

    symbols_above = Enum.at(symbol_lines, index - 1)
    symbols_adjacent = Enum.at(symbol_lines, index)
    symbols_below = Enum.at(symbol_lines, index + 1) || []

    [symbols_above, symbols_adjacent, symbols_below]
    |> Enum.any?(fn (symbols) ->
      symbols |> Enum.any?(fn ({x, _}) ->
        Enum.member?(neighboring_range, x)
      end)
    end)
  end
end
