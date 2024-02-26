defmodule Day18Test do
  use ExUnit.Case

  test "Day 18 example should pass" do
    assert Day18.main("inputs/day_18_example.txt") === 62
  end

  test "Day 18 input should pass" do
    assert Day18.main("inputs/day_18_input.txt") === 39194
  end
end
