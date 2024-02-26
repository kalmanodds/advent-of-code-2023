defmodule Day12Test do
  use ExUnit.Case

  test "Day 12 example should pass" do
    assert Day12.main("inputs/day_12_example.txt") === 21
  end

  test "valid_configuration? should pass the base case" do
    valid_config = "#.#.### 1,1,3"
    assert Day12.valid_configuration?(valid_config) === true
  end

  # Runs for 60ish seconds
  @tag timeout: :infinity
  @tag :skip
  test "Day 12 input should pass" do
    assert Day12.main("inputs/day_12_input.txt") === 7506
  end
end
