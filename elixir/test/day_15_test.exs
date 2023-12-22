defmodule Day15Test do
  use ExUnit.Case

  test "Day 15 example should pass" do
    assert Day15.main("inputs/day_15_example.txt") === 1320
  end

  test "running hash_step on \"HASH\" should work" do
    assert Day15.hash_step("HASH") === 52
  end

  test "Day 15 input should pass" do
    assert Day15.main("inputs/day_15_input.txt") === 507666
  end
end
