defmodule Day22Test do
  use ExUnit.Case

  test "Day 22 example should pass" do
    assert Day22.main("inputs/day_22_example.txt") === 5
  end

  test "insert_forward should pass the base case" do
    actual = Day22.insert_forward(%{}, {1, 0}, :label, 3)
    expected = %{0 => [[], [:label], []]}
    assert (actual === expected)
  end

  test "insert_horizontal should pass the base case" do
    actual = Day22.insert_horizontal(%{}, {0, 2, 0}, :label, 3)
    expected = %{0 => [[:label], [:label], [:label]]}
    assert (actual === expected)
  end

  @tag :skip
  test "Day 22 input should pass" do
    assert Day22.main("inputs/day_22_input.txt") === 0
  end
end
