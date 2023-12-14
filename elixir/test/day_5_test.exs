defmodule Day5Test do
  use ExUnit.Case

  test "Day 5 example should pass" do
    assert Day5.main("inputs/day_5_example.txt") === 35
  end

  test "Day 5 input should pass" do
    assert Day5.main("inputs/day_5_input.txt") === 309796150
  end
end
