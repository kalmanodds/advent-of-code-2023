defmodule Day13Test do
  use ExUnit.Case

  test "Day 13 example should pass" do
    assert Day13.main("inputs/day_13_example.txt") === 405
  end

  test "get_horizontal_reflection_offset should pass the base case" do
    pattern = [
      "#...##..#",
      "#....#..#",
      "..##..###",
      "#####.##.",
      "#####.##.",
      "..##..###",
      "#....#..#"
    ]
    assert Day13.get_horizontal_reflection_offset(pattern) === 4
  end

  test "get_vertical_reflection_offset should pass the base case" do
    pattern = [
      "#.##..##.",
      "..#.##.#.",
      "##......#",
      "##......#",
      "..#.##.#.",
      "..##..##.",
      "#.#.##.#."
    ]
    assert Day13.get_vertical_reflection_offset(pattern) === 5
  end

  test "Day 13 input should pass" do
    assert Day13.main("inputs/day_13_input.txt") === 29130
  end
end
