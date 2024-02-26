defmodule Day8Test do
  use ExUnit.Case

  test "Day 8 example 1 should pass" do
    assert Day8.main("inputs/day_8_example_1.txt") === 2
  end

  test "Day 8 example 2 should pass" do
    assert Day8.main("inputs/day_8_example_2.txt") === 6
  end

  test "Day 8 input should pass" do
    assert Day8.main("inputs/day_8_input.txt") === 21797
  end
end
