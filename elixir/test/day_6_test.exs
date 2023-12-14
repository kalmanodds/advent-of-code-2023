defmodule Day6Test do
  use ExUnit.Case

  test "Day 6 example should pass" do
    assert Day6.main("inputs/day_6_example.txt") === 288
  end

  test "Day 6 input should pass" do
    assert Day6.main("inputs/day_6_input.txt") === 2065338
  end
end
