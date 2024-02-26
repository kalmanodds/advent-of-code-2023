defmodule Day19 do
  def main(file_path) do
    {_, content} = File.read(file_path)
    [workflows, parts] = content |> String.split("\r\n\r\n")

    workflows = create_workflow_map(workflows)
    workflow = workflows |> Map.get("in")

    parts
    |> create_part_maps()
    |> Enum.filter(&is_accepted_part?(&1, workflow, workflows))
    |> Enum.reduce(0, fn (part, acc) ->
      part_sum = part |> Map.values() |> Enum.sum()
      acc + part_sum
    end)
  end

  def create_workflow_map(workflow_string) do
    initial_map = %{"A" => ["A"], "R" => ["R"]}
    workflow_string
    |> String.split("\r\n")
    |> Enum.reduce(initial_map, fn (row, workflow_map) ->
      [key, rules] = row |> String.split(["{", "}"], trim: true)
      rules = rules |> String.split(",")
      workflow_map |> Map.put(key, rules)
    end)
  end

  def create_part_maps(parts) do
    parts
    |> String.split("\r\n")
    |> Enum.map(fn (part) ->
      part
      |> String.split(["{", "}", ","], trim: true)
      |> Enum.reduce(%{}, fn (part, part_map) ->
        [key, value] = part |> String.split("=")
        value = value |> String.to_integer()
        part_map |> Map.put(key, value)
      end)
    end)
  end


  def is_accepted_part?(part, workflow, workflows)
  def is_accepted_part?(_part, ["A" | _rest], _workflows) do true end
  def is_accepted_part?(_part, ["R" | _rest], _workflows) do false end
  def is_accepted_part?(part, [rule | rest], workflows) do
    case workflows |> Map.get(rule) do
      nil ->
        {part_key, comparator, value, workflow_key} = parse_rule(rule)
        part_value = part |> Map.get(part_key)
        workflow = case condition_passes?(part_value, value, comparator) do
          true -> workflows |> Map.get(workflow_key)
          false -> rest
        end
        is_accepted_part?(part, workflow, workflows)
      rules -> is_accepted_part?(part, rules, workflows)
    end
  end

  def parse_rule(rule) do
    {part_key, rest} = rule |> String.split_at(1)
    {comparator, rest} = rest |> String.split_at(1)
    [value, workflow_key] = rest |> String.split(":")
    {part_key, comparator, String.to_integer(value), workflow_key}
  end

  def condition_passes?(value1, value2, comparator) do
    case comparator do
      "<" -> value1 < value2
      ">" -> value1 > value2
    end
  end
end
