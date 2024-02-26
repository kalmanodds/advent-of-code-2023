defmodule Day7Test do
  use ExUnit.Case

  test "Day 7 example should pass" do
    assert Day7.main("inputs/day_7_example.txt") === 6440
  end

  test "Day 7 input should pass" do
    assert Day7.main("inputs/day_7_input.txt") === 248217452
  end
end
