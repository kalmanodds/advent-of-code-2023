defmodule Day19Test do
  use ExUnit.Case

  test "Day 19 example should pass" do
    assert Day19.main("inputs/day_19_example.txt") === 19114
  end

  test "parse_rule should parse correctly" do
    rule = "s>2770:qs"
    expected = {"s", ">", 2770, "qs"}
    assert Day19.parse_rule(rule) === expected
  end

  test "Day 19 input should pass" do
    assert Day19.main("inputs/day_19_input.txt") === 0
  end
end
