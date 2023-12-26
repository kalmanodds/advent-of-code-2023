defmodule Day18Test do
  use ExUnit.Case

  test "Day 18 example should pass" do
    assert Day18.main("inputs/day_18_example.txt") === 62
  end

  test "find_dimensions should pass the base case" do
    assert Day18.find_dimensions([{"R", 6}]) === [6, 0]
  end

  @tag :skip
  test "Day 18 input should pass" do
    assert Day18.main("inputs/day_18_input.txt") === 0
  end
end
