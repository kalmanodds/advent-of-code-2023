defmodule Day16Test do
  use ExUnit.Case

  test "Day 16 example should pass" do
    assert Day16.main("inputs/day_16_example.txt") === 46
  end

  test "out_of_bounds? should pass" do
    assert Day16.out_of_bounds?([[]], {-1, 0}) === true
  end

  test "traverse_grid should pass a simple dot grid" do
    grid = [[".", "."], [".", "."]]
    expected = %{{0, 0} => :right, {1, 0} => :right}
    assert Day16.traverse_grid(grid) === expected
  end

  test "Day 16 input should pass" do
    assert Day16.main("inputs/day_16_input.txt") === 7067
  end
end
