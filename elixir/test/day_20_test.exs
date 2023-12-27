defmodule Day20Test do
  use ExUnit.Case

  @tag :skip
  test "Day 20 example should pass" do
    assert Day20.main("inputs/day_20_example.txt") === 32000000
  end

  test "process_broadcast should update queue" do
    signal = {:low, nil, "broadcaster"}
    module = {:broadcaster, ["a", "b", "c"], nil}

    expected_queue = [
      {:low, "broadcaster", "a"},
      {:low, "broadcaster", "b"},
      {:low, "broadcaster", "c"}
    ]
    expected = {expected_queue, %{}}
    assert Day20.process_broadcast(signal, module, [], %{}) === expected
  end

  test "process_flip_flop should process :low signals correctly" do
    signal = {:low, nil, "a"}
    module = {:flip_flop, ["b"], :low}
    module_map = %{"a" => module, "b" => module}

    expected_module = {:flip_flop, ["b"], :high}
    expected_module_map = %{"a" => expected_module, "b" => module}
    expected = {[{:high, "a", "b"}], expected_module_map}

    assert Day20.process_flip_flop(signal, module, [], module_map) === expected
  end

  test "process_flip_flop should ignore :high signals" do
    signal = {:high, nil, "a"}
    module = {:flip_flop, ["b"], :low}
    module_map = %{"a" => module}

    expected = {[], module_map}
    assert Day20.process_flip_flop(signal, module, [], module_map) === expected
  end

  test "Day 20 input should pass" do
    assert Day20.main("inputs/day_20_input.txt") === 841763884
  end
end
