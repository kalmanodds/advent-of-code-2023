defmodule Day17Test do
  use ExUnit.Case

  @tag :skip
  test "Day 17 example should pass" do
    assert Day17.main("inputs/day_17_example.txt") === 102
  end

  @tag :skip
  test "Day 17 input should pass" do
    assert Day17.main("inputs/day_17_input.txt") === 0
  end
end
