defmodule Day9Test do
  use ExUnit.Case

  test "Day 9 example 1 should pass" do
    assert Day9.main("inputs/day_9_example.txt") === 114
  end

  test "Day 9 input should pass" do
    assert Day9.main("inputs/day_9_input.txt") === 21797
  end
end
