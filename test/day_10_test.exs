defmodule Day10Test do
  use ExUnit.Case

  test "Day 10 example 1 should pass" do
    assert Day10.main("inputs/day_10_example_1.txt") === 8
  end

  test "Day 10 example 2 should pass" do
    assert Day10.main("inputs/day_10_example_2.txt") === 4
  end

  test "Day 10 input should pass" do
    assert Day10.main("inputs/day_10_input.txt") === 6754
  end
end
