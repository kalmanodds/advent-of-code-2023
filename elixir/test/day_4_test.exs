defmodule Day4Test do
  use ExUnit.Case

  test "Day 4 example should pass" do
    assert Day4.main("inputs/day_4_example.txt") === 13
  end

  test "Day 4 input should pass" do
    assert Day4.main("inputs/day_4_input.txt") === 23028
  end
end
