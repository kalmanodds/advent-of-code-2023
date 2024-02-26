defmodule Day14Test do
  use ExUnit.Case

  test "Day 14 example should pass" do
    assert Day14.main("inputs/day_14_example.txt") === 136
  end

  test "tilt_row should pass the base case" do
    row = "OO.O.O..##"
    expected = "OOOO....##"
    assert Day14.tilt_row(row) === expected
  end

  test "Day 14 input should pass" do
    assert Day14.main("inputs/day_14_input.txt") === 106648
  end
end
