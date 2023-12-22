defmodule Day16Test do
  use ExUnit.Case

  test "Day 16 example should pass" do
    assert Day16.main("inputs/day_16_example.txt") === 46
  end

  test "Day 16 input should pass" do
    assert Day16.main("inputs/day_16_input.txt") === 0
  end
end
