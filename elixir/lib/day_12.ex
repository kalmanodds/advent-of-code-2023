defmodule Day12 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    records = content
    |> String.split("\r\n")

    permutations = records
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn (record) ->
      record
      |> Enum.frequencies()
      |> Map.get("?")
      |> create_permutations()
    end)

    [records, permutations]
    |> Enum.zip()
    |> create_configurations()
    |> valid_configuration_counts()
  end

  def create_permutations(0) do [[]] end
  def create_permutations(length) do
    list = ["#", "."]
    for x <- list, y <- create_permutations(length - 1), do: [x|y]
  end

  def create_configurations(permutation_list) do
    permutation_list |> Enum.map(fn {record, permutations} ->
      permutations |> Enum.map(fn (permutation) ->
        permutation |> Enum.reduce(record, fn (symbol, acc) ->
          acc |> String.replace("?", symbol, global: false)
        end)
      end)
    end)
  end

  def valid_configuration_counts(configurations_list) do
    configurations_list |> Enum.reduce(0, fn (configurations, acc) ->
      valid_configurations = configurations
      |> Enum.reduce(0, fn (configuration, acc) ->
        acc + if valid_configuration?(configuration), do: 1, else: 0
      end)
      acc + valid_configurations
    end)
  end

  def valid_configuration?(configuration) do
    [configuration, numbers] = configuration |> String.split(" ")
    hashes = configuration |> String.split(".", trim: true)
    numbers = numbers
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    case Enum.count(hashes) === Enum.count(numbers) do
      true -> [hashes, numbers]
        |> Enum.zip()
        |> Enum.all?(fn {hash, number} ->
          String.length(hash) === number
        end)
      false -> false
    end
  end
end
