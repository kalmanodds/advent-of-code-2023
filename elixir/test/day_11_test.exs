defmodule Day11Test do
  use ExUnit.Case

  test "Day 11 example 1 should pass" do
    assert Day11.main("inputs/day_11_example.txt") === 374
  end

  test "expand_row should work" do
    row = List.duplicate(".", 3) |> Enum.with_index()
    x_gaps = [1]
    assert Day11.expand_row(row, x_gaps) === [".", ".", ".", "."]
  end

  test "find_galaxies should index2 galaxies correctly in the same line" do
    line = {[".", "#", "#"], 0}
    assert Day11.find_galaxies([line]) === [{1, 0},{2, 0}]
  end

  test "find_galaxies should index 3 galaxies correctly in the same line" do
    line = {["#", "#", "#"], 0}
    assert Day11.find_galaxies([line]) === [{0, 0},{1, 0},{2, 0}]
  end

  test "find_galaxies should index 4 galaxies correctly in the same line" do
    line = {["#", "#", "#", "#"], 0}
    assert Day11.find_galaxies([line]) === [{0, 0},{1, 0},{2, 0},{3, 0}]
  end

  test "Day 11 input should pass" do
    assert Day11.main("inputs/day_11_input.txt") == 10165598
  end
end
