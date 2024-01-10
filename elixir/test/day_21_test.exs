defmodule Day21Test do
  use ExUnit.Case

  test "Day 21 example should pass" do
    assert Day21.main("inputs/day_21_example.txt", 6) === 16
  end

  test "Day 21 input should pass" do
    assert Day21.main("inputs/day_21_input.txt") === 0
  end
end
