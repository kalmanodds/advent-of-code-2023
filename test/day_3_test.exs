defmodule Day3Test do
  use ExUnit.Case

  test "Day 3 example should pass" do
    assert Day3.main("inputs/day_3_example.txt") === 4361
  end

  test "Day 3 input should pass" do
    assert Day3.main("inputs/day_3_input.txt") === 522726
  end
end
